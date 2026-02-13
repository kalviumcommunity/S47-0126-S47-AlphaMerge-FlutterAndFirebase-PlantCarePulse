import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plant.dart';
import '../models/user_plant.dart';
import '../models/care_activity.dart';

/// Firestore Service
/// Handles all Firestore read and write operations for the app
class FirestoreService {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  static const String plantsCollection = 'plants';
  static const String userPlantsCollection = 'user_plants';
  static const String careActivitiesCollection = 'care_activities';
  static const String usersCollection = 'users';

  // ==================== PLANT LIBRARY OPERATIONS ====================

  /// Get all plants from the library (one-time read)
  Future<List<Plant>> getAllPlants() async {
    try {
      final snapshot = await _firestore.collection(plantsCollection).get();
      return snapshot.docs.map((doc) => Plant.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting plants: $e');
      return [];
    }
  }

  /// Get a single plant by ID (one-time read)
  Future<Plant?> getPlantById(String plantId) async {
    try {
      final doc = await _firestore.collection(plantsCollection).doc(plantId).get();
      if (doc.exists) {
        return Plant.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting plant: $e');
      return null;
    }
  }

  /// Stream all plants (real-time updates)
  Stream<List<Plant>> getPlantsStream() {
    return _firestore
        .collection(plantsCollection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Plant.fromFirestore(doc)).toList());
  }

  /// Stream plants by category (real-time with filter)
  Stream<List<Plant>> getPlantsByCategoryStream(String category) {
    return _firestore
        .collection(plantsCollection)
        .where('category', isEqualTo: category)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Plant.fromFirestore(doc)).toList());
  }

  /// Stream plants by difficulty (real-time with filter)
  Stream<List<Plant>> getPlantsByDifficultyStream(String difficulty) {
    return _firestore
        .collection(plantsCollection)
        .where('difficulty', isEqualTo: difficulty)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Plant.fromFirestore(doc)).toList());
  }

  // ==================== USER PLANTS OPERATIONS ====================

  /// Get all user plants for a specific user (one-time read)
  Future<List<UserPlant>> getUserPlants(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(userPlantsCollection)
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      List<UserPlant> userPlants = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final plantId = data['plantId'];
        final plant = await getPlantById(plantId);
        if (plant != null) {
          userPlants.add(UserPlant.fromFirestore(doc, plant));
        }
      }
      return userPlants;
    } catch (e) {
      print('Error getting user plants: $e');
      return [];
    }
  }

  /// Stream user plants (real-time updates)
  Stream<List<UserPlant>> getUserPlantsStream(String userId) {
    return _firestore
        .collection(userPlantsCollection)
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('dateAdded', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<UserPlant> userPlants = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final plantId = data['plantId'];
        final plant = await getPlantById(plantId);
        if (plant != null) {
          userPlants.add(UserPlant.fromFirestore(doc, plant));
        }
      }
      return userPlants;
    });
  }

  /// Stream user plants that need watering (real-time with filter)
  Stream<List<UserPlant>> getPlantsNeedingWaterStream(String userId) {
    return _firestore
        .collection(userPlantsCollection)
        .where('userId', isEqualTo: userId)
        .where('healthStatus', isEqualTo: 'warning')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<UserPlant> userPlants = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final plantId = data['plantId'];
        final plant = await getPlantById(plantId);
        if (plant != null) {
          userPlants.add(UserPlant.fromFirestore(doc, plant));
        }
      }
      return userPlants;
    });
  }

  /// Get a single user plant by ID
  Future<UserPlant?> getUserPlantById(String userPlantId) async {
    try {
      final doc = await _firestore.collection(userPlantsCollection).doc(userPlantId).get();
      if (doc.exists) {
        final data = doc.data()!;
        final plantId = data['plantId'];
        final plant = await getPlantById(plantId);
        if (plant != null) {
          return UserPlant.fromFirestore(doc, plant);
        }
      }
      return null;
    } catch (e) {
      print('Error getting user plant: $e');
      return null;
    }
  }

  // ==================== CARE ACTIVITIES OPERATIONS ====================

  /// Get care activities for a user plant (one-time read)
  Future<List<CareActivity>> getCareActivities(String userPlantId) async {
    try {
      final snapshot = await _firestore
          .collection(userPlantsCollection)
          .doc(userPlantId)
          .collection(careActivitiesCollection)
          .orderBy('performedAt', descending: true)
          .limit(50)
          .get();

      return snapshot.docs.map((doc) => CareActivity.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting care activities: $e');
      return [];
    }
  }

  /// Stream care activities (real-time updates)
  Stream<List<CareActivity>> getCareActivitiesStream(String userPlantId) {
    return _firestore
        .collection(userPlantsCollection)
        .doc(userPlantId)
        .collection(careActivitiesCollection)
        .orderBy('performedAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => CareActivity.fromFirestore(doc)).toList());
  }

  /// Stream care activities by type (real-time with filter)
  Stream<List<CareActivity>> getCareActivitiesByTypeStream(
    String userPlantId,
    String activityType,
  ) {
    return _firestore
        .collection(userPlantsCollection)
        .doc(userPlantId)
        .collection(careActivitiesCollection)
        .where('activityType', isEqualTo: activityType)
        .orderBy('performedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => CareActivity.fromFirestore(doc)).toList());
  }

  /// Get recent care activities across all user plants
  Stream<List<Map<String, dynamic>>> getRecentCareActivitiesStream(String userId) {
    return _firestore
        .collection(userPlantsCollection)
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .asyncMap((userPlantsSnapshot) async {
      List<Map<String, dynamic>> allActivities = [];

      for (var userPlantDoc in userPlantsSnapshot.docs) {
        final activitiesSnapshot = await _firestore
            .collection(userPlantsCollection)
            .doc(userPlantDoc.id)
            .collection(careActivitiesCollection)
            .orderBy('performedAt', descending: true)
            .limit(10)
            .get();

        for (var activityDoc in activitiesSnapshot.docs) {
          allActivities.add({
            'activity': CareActivity.fromFirestore(activityDoc),
            'userPlantId': userPlantDoc.id,
            'plantNickname': userPlantDoc.data()['nickname'] ?? 'Unknown Plant',
          });
        }
      }

      // Sort by date
      allActivities.sort((a, b) {
        final aDate = (a['activity'] as CareActivity).performedAt;
        final bDate = (b['activity'] as CareActivity).performedAt;
        return bDate.compareTo(aDate);
      });

      return allActivities.take(20).toList();
    });
  }

  // ==================== USER PROFILE OPERATIONS ====================

  /// Get user profile data
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection(usersCollection).doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Stream user profile (real-time updates)
  Stream<Map<String, dynamic>?> getUserProfileStream(String userId) {
    return _firestore.collection(usersCollection).doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return doc.data();
      }
      return null;
    });
  }

  // ==================== STATISTICS OPERATIONS ====================

  /// Get user statistics
  Future<Map<String, int>> getUserStatistics(String userId) async {
    try {
      // Count total plants
      final plantsSnapshot = await _firestore
          .collection(userPlantsCollection)
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      int totalPlants = plantsSnapshot.docs.length;
      int plantsNeedingWater = 0;

      // Count plants needing water
      for (var doc in plantsSnapshot.docs) {
        final data = doc.data();
        if (data['healthStatus'] == 'warning') {
          plantsNeedingWater++;
        }
      }

      // Count total care activities
      int totalActivities = 0;
      for (var doc in plantsSnapshot.docs) {
        final activitiesSnapshot = await _firestore
            .collection(userPlantsCollection)
            .doc(doc.id)
            .collection(careActivitiesCollection)
            .get();
        totalActivities += activitiesSnapshot.docs.length;
      }

      return {
        'totalPlants': totalPlants,
        'plantsNeedingWater': plantsNeedingWater,
        'totalActivities': totalActivities,
        'healthyPlants': totalPlants - plantsNeedingWater,
      };
    } catch (e) {
      print('Error getting statistics: $e');
      return {
        'totalPlants': 0,
        'plantsNeedingWater': 0,
        'totalActivities': 0,
        'healthyPlants': 0,
      };
    }
  }

  // ==================== WRITE OPERATIONS (for completeness) ====================

  /// Add a plant to the library
  Future<String?> addPlant(Plant plant) async {
    try {
      final docRef = await _firestore.collection(plantsCollection).add(plant.toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding plant: $e');
      return null;
    }
  }

  /// Add a plant to user's collection
  Future<String?> addUserPlant(String userId, UserPlant userPlant) async {
    try {
      final data = userPlant.toMap();
      data['userId'] = userId;
      final docRef = await _firestore.collection(userPlantsCollection).add(data);
      return docRef.id;
    } catch (e) {
      print('Error adding user plant: $e');
      return null;
    }
  }

  /// Add a care activity
  Future<String?> addCareActivity(String userPlantId, CareActivity activity) async {
    try {
      final docRef = await _firestore
          .collection(userPlantsCollection)
          .doc(userPlantId)
          .collection(careActivitiesCollection)
          .add(activity.toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding care activity: $e');
      return null;
    }
  }

  /// Update user plant
  Future<bool> updateUserPlant(String userPlantId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(userPlantsCollection).doc(userPlantId).update(data);
      return true;
    } catch (e) {
      print('Error updating user plant: $e');
      return false;
    }
  }

  /// Initialize sample data (for testing)
  Future<void> initializeSampleData() async {
    try {
      // Add sample plants to library
      final plants = Plant.getSamplePlants();
      for (var plant in plants) {
        await _firestore.collection(plantsCollection).doc(plant.id).set(plant.toMap());
      }
      print('Sample data initialized successfully');
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }
}
