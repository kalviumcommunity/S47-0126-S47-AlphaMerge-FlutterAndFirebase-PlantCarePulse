import 'package:cloud_firestore/cloud_firestore.dart';
import 'plant.dart';

class UserPlant {
  final String id;
  final Plant plant;
  final String nickname;
  final DateTime dateAdded;
  DateTime? lastWatered;
  final String location;
  String notes;

  UserPlant({
    required this.id,
    required this.plant,
    required this.nickname,
    required this.dateAdded,
    this.lastWatered,
    required this.location,
    this.notes = '',
  });

  DateTime get nextWateringDate {
    if (lastWatered == null) {
      return DateTime.now();
    }
    return lastWatered!.add(Duration(days: plant.wateringFrequencyDays));
  }

  int get daysUntilWatering {
    return nextWateringDate.difference(DateTime.now()).inDays;
  }

  bool get needsWatering {
    return daysUntilWatering <= 0;
  }

  String get wateringStatus {
    if (needsWatering) return 'Needs Water Now!';
    if (daysUntilWatering == 1) return 'Water Tomorrow';
    return 'Water in $daysUntilWatering days';
  }

  void water() {
    lastWatered = DateTime.now();
  }

  // Convert UserPlant to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userPlantId': id,
      'plantId': plant.id,
      'nickname': nickname,
      'location': location,
      'dateAdded': Timestamp.fromDate(dateAdded),
      'lastWatered': lastWatered != null ? Timestamp.fromDate(lastWatered!) : null,
      'nextWateringDate': Timestamp.fromDate(nextWateringDate),
      'wateringFrequencyDays': plant.wateringFrequencyDays,
      'healthStatus': needsWatering ? 'warning' : 'healthy',
      'notes': notes,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Create UserPlant from Firestore document
  factory UserPlant.fromMap(Map<String, dynamic> map, Plant plant, String documentId) {
    return UserPlant(
      id: documentId,
      plant: plant,
      nickname: map['nickname'] ?? '',
      location: map['location'] ?? '',
      dateAdded: (map['dateAdded'] as Timestamp).toDate(),
      lastWatered: map['lastWatered'] != null 
          ? (map['lastWatered'] as Timestamp).toDate() 
          : null,
      notes: map['notes'] ?? '',
    );
  }

  // Create UserPlant from Firestore DocumentSnapshot
  factory UserPlant.fromFirestore(DocumentSnapshot doc, Plant plant) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserPlant.fromMap(data, plant, doc.id);
  }
}
