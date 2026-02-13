import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_plant.dart';
import '../models/care_activity.dart';
import '../models/plant.dart';
import '../models/user.dart';

/// Firestore Service
/// Handles all Firestore write and read operations securely
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _plantsCollection => _firestore.collection('plants');
  CollectionReference get _userPlantsCollection => _firestore.collection('userPlants');

  // ==================== USER OPERATIONS ====================

  /// Create or update user profile
  /// Uses set with merge to avoid overwriting existing data
  Future<void> saveUserProfile(UserModel user) async {
    try {
      await _usersCollection.doc(user.userId).set(
        user.toMap(),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  /// Update specific user fields
  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    try {
      // Validate userId
      if (userId.isEmpty) {
        throw Exception('User ID cannot be empty');
      }

      // Add timestamp
      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _usersCollection.doc(userId).update(updates);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Get user profile
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // ==================== PLANT LIBRARY OPERATIONS ====================

  /// Add a new plant to the library (admin operation)
  Future<String> addPlantToLibrary(Plant plant) async {
    try {
      final docRef = await _plantsCollection.add(plant.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add plant to library: $e');
    }
  }

  /// Get all plants from library
  Stream<List<Plant>> getPlantsLibrary() {
    return _plantsCollection
        .orderBy('commonName')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Plant.fromFirestore(doc))
            .toList());
  }

  // ==================== USER PLANT OPERATIONS ====================

  /// Add a new plant to user's collection
  /// Validates all required fields before writing
  /// Stores plant data directly with user plant for better performance
  Future<String> addUserPlant({
    required String userId,
    required Plant plant,
    required String nickname,
    required String location,
    String notes = '',
  }) async {
    try {
      // Validate inputs
      if (userId.isEmpty) throw Exception('User ID is required');
      if (nickname.trim().isEmpty) throw Exception('Nickname is required');
      if (location.trim().isEmpty) throw Exception('Location is required');

      // Add to Firestore with embedded plant data
      final docRef = await _userPlantsCollection.add({
        'userId': userId,
        'plantId': plant.id,
        'plantName': plant.name,
        'plantScientificName': plant.scientificName,
        'plantEmoji': plant.imageEmoji,
        'wateringFrequencyDays': plant.wateringFrequencyDays,
        'sunlight': plant.sunlight,
        'difficulty': plant.difficulty,
        'category': plant.category,
        'description': plant.description,
        'careTips': plant.careTips,
        'nickname': nickname.trim(),
        'location': location.trim(),
        'dateAdded': Timestamp.now(),
        'lastWatered': null,
        'notes': notes.trim(),
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add plant: $e');
    }
  }

  /// Update user plant details
  /// Only updates specified fields, doesn't overwrite entire document
  Future<void> updateUserPlant(String userPlantId, Map<String, dynamic> updates) async {
    try {
      // Validate userPlantId
      if (userPlantId.isEmpty) {
        throw Exception('User plant ID cannot be empty');
      }

      // Validate that we're not trying to update protected fields
      final protectedFields = ['userId', 'plantId', 'dateAdded', 'createdAt'];
      for (var field in protectedFields) {
        if (updates.containsKey(field)) {
          throw Exception('Cannot update protected field: $field');
        }
      }

      // Add timestamp
      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _userPlantsCollection.doc(userPlantId).update(updates);
    } catch (e) {
      throw Exception('Failed to update plant: $e');
    }
  }

  /// Record watering activity
  /// Updates lastWatered timestamp and creates activity log
  Future<void> waterPlant(String userPlantId, String userId, {String? notes}) async {
    try {
      if (userPlantId.isEmpty) throw Exception('User plant ID is required');
      if (userId.isEmpty) throw Exception('User ID is required');

      final now = Timestamp.now();

      // Update user plant with proper Timestamp
      await _userPlantsCollection.doc(userPlantId).update({
        'lastWatered': now,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create care activity
      await addCareActivity(
        userPlantId: userPlantId,
        userId: userId,
        activityType: 'watering',
        notes: notes,
      );
    } catch (e) {
      throw Exception('Failed to record watering: $e');
    }
  }

  /// Get user's plants
  Stream<List<UserPlant>> getUserPlants(String userId) {
    return _userPlantsCollection
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      List<UserPlant> userPlants = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Reconstruct Plant object from embedded data
        final plant = Plant(
          id: data['plantId'] ?? '',
          name: data['plantName'] ?? '',
          scientificName: data['plantScientificName'] ?? '',
          category: data['category'] ?? 'Indoor',
          imageEmoji: data['plantEmoji'] ?? '🌱',
          wateringFrequencyDays: data['wateringFrequencyDays'] ?? 7,
          sunlight: data['sunlight'] ?? '',
          difficulty: data['difficulty'] ?? 'Medium',
          description: data['description'] ?? '',
          careTips: List<String>.from(data['careTips'] ?? []),
        );
        
        userPlants.add(UserPlant.fromMap(data, plant, doc.id));
      }
      
      // Sort in memory instead of using orderBy
      userPlants.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
      
      return userPlants;
    });
  }

  /// Delete user plant (soft delete)
  Future<void> deleteUserPlant(String userPlantId) async {
    try {
      if (userPlantId.isEmpty) {
        throw Exception('User plant ID cannot be empty');
      }

      await _userPlantsCollection.doc(userPlantId).update({
        'isActive': false,
        'deletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to delete plant: $e');
    }
  }

  // ==================== CARE ACTIVITY OPERATIONS ====================

  /// Add a care activity
  /// Validates activity type and required fields
  Future<String> addCareActivity({
    required String userPlantId,
    required String userId,
    required String activityType,
    String? notes,
    String? amount,
  }) async {
    try {
      // Validate inputs
      if (userPlantId.isEmpty) throw Exception('User plant ID is required');
      if (userId.isEmpty) throw Exception('User ID is required');
      if (activityType.isEmpty) throw Exception('Activity type is required');

      // Validate activity type
      final validTypes = ['watering', 'fertilizing', 'pruning', 'repotting', 'observation'];
      if (!validTypes.contains(activityType)) {
        throw Exception('Invalid activity type: $activityType');
      }

      // Create activity
      final docRef = await _userPlantsCollection
          .doc(userPlantId)
          .collection('activities')
          .add({
        'userId': userId,
        'activityType': activityType,
        'performedAt': Timestamp.now(),
        'notes': notes?.trim(),
        'amount': amount?.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add care activity: $e');
    }
  }

  /// Get care activities for a plant
  Stream<List<CareActivity>> getCareActivities(String userPlantId) {
    return _userPlantsCollection
        .doc(userPlantId)
        .collection('activities')
        .orderBy('performedAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CareActivity.fromFirestore(doc))
            .toList());
  }

  /// Update care activity
  Future<void> updateCareActivity(
    String userPlantId,
    String activityId,
    Map<String, dynamic> updates,
  ) async {
    try {
      if (userPlantId.isEmpty) throw Exception('User plant ID is required');
      if (activityId.isEmpty) throw Exception('Activity ID is required');

      await _userPlantsCollection
          .doc(userPlantId)
          .collection('activities')
          .doc(activityId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update activity: $e');
    }
  }

  /// Delete care activity
  Future<void> deleteCareActivity(String userPlantId, String activityId) async {
    try {
      if (userPlantId.isEmpty) throw Exception('User plant ID is required');
      if (activityId.isEmpty) throw Exception('Activity ID is required');

      await _userPlantsCollection
          .doc(userPlantId)
          .collection('activities')
          .doc(activityId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete activity: $e');
    }
  }

  // ==================== BATCH OPERATIONS ====================

  /// Batch update multiple plants
  /// Useful for bulk operations
  Future<void> batchUpdatePlants(Map<String, Map<String, dynamic>> updates) async {
    try {
      final batch = _firestore.batch();

      updates.forEach((plantId, updateData) {
        updateData['updatedAt'] = FieldValue.serverTimestamp();
        batch.update(_userPlantsCollection.doc(plantId), updateData);
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to batch update plants: $e');
    }
  }
}
