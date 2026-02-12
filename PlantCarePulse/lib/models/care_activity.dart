import 'package:cloud_firestore/cloud_firestore.dart';

/// Care Activity Model
/// Represents a care activity performed on a user's plant
class CareActivity {
  final String id;
  final String activityType; // watering, fertilizing, pruning, repotting, observation
  final DateTime performedAt;
  final String? notes;
  final String? amount;
  final String? imageUrl;

  CareActivity({
    required this.id,
    required this.activityType,
    required this.performedAt,
    this.notes,
    this.amount,
    this.imageUrl,
  });

  // Convert CareActivity to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'activityId': id,
      'activityType': activityType,
      'performedAt': Timestamp.fromDate(performedAt),
      'notes': notes,
      'amount': amount,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Create CareActivity from Firestore document
  factory CareActivity.fromMap(Map<String, dynamic> map, String documentId) {
    return CareActivity(
      id: documentId,
      activityType: map['activityType'] ?? 'observation',
      performedAt: (map['performedAt'] as Timestamp).toDate(),
      notes: map['notes'],
      amount: map['amount'],
      imageUrl: map['imageUrl'],
    );
  }

  // Create CareActivity from Firestore DocumentSnapshot
  factory CareActivity.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CareActivity.fromMap(data, doc.id);
  }

  // Get icon for activity type
  String get activityIcon {
    switch (activityType) {
      case 'watering':
        return '💧';
      case 'fertilizing':
        return '🌱';
      case 'pruning':
        return '✂️';
      case 'repotting':
        return '🪴';
      case 'observation':
        return '👁️';
      default:
        return '📝';
    }
  }

  // Get display name for activity type
  String get activityDisplayName {
    switch (activityType) {
      case 'watering':
        return 'Watering';
      case 'fertilizing':
        return 'Fertilizing';
      case 'pruning':
        return 'Pruning';
      case 'repotting':
        return 'Repotting';
      case 'observation':
        return 'Observation';
      default:
        return 'Activity';
    }
  }
}
