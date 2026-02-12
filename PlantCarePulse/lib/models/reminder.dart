import 'package:cloud_firestore/cloud_firestore.dart';

/// Reminder Model
/// Represents a scheduled care reminder for a user's plant
class Reminder {
  final String id;
  final String userPlantId;
  final String reminderType; // watering, fertilizing, pruning
  final DateTime scheduledFor;
  final bool isCompleted;
  final DateTime? completedAt;
  final bool isRecurring;
  final int? recurringDays;

  Reminder({
    required this.id,
    required this.userPlantId,
    required this.reminderType,
    required this.scheduledFor,
    this.isCompleted = false,
    this.completedAt,
    this.isRecurring = false,
    this.recurringDays,
  });

  // Convert Reminder to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'reminderId': id,
      'userPlantId': userPlantId,
      'reminderType': reminderType,
      'scheduledFor': Timestamp.fromDate(scheduledFor),
      'isCompleted': isCompleted,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'isRecurring': isRecurring,
      'recurringDays': recurringDays,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Create Reminder from Firestore document
  factory Reminder.fromMap(Map<String, dynamic> map, String documentId) {
    return Reminder(
      id: documentId,
      userPlantId: map['userPlantId'] ?? '',
      reminderType: map['reminderType'] ?? 'watering',
      scheduledFor: (map['scheduledFor'] as Timestamp).toDate(),
      isCompleted: map['isCompleted'] ?? false,
      completedAt: map['completedAt'] != null 
          ? (map['completedAt'] as Timestamp).toDate() 
          : null,
      isRecurring: map['isRecurring'] ?? false,
      recurringDays: map['recurringDays'],
    );
  }

  // Create Reminder from Firestore DocumentSnapshot
  factory Reminder.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reminder.fromMap(data, doc.id);
  }

  // Check if reminder is overdue
  bool get isOverdue {
    return !isCompleted && scheduledFor.isBefore(DateTime.now());
  }

  // Check if reminder is due today
  bool get isDueToday {
    final now = DateTime.now();
    return !isCompleted && 
           scheduledFor.year == now.year &&
           scheduledFor.month == now.month &&
           scheduledFor.day == now.day;
  }

  // Get days until reminder
  int get daysUntil {
    return scheduledFor.difference(DateTime.now()).inDays;
  }

  // Get icon for reminder type
  String get reminderIcon {
    switch (reminderType) {
      case 'watering':
        return '💧';
      case 'fertilizing':
        return '🌱';
      case 'pruning':
        return '✂️';
      default:
        return '🔔';
    }
  }

  // Get display name for reminder type
  String get reminderDisplayName {
    switch (reminderType) {
      case 'watering':
        return 'Water Plant';
      case 'fertilizing':
        return 'Fertilize Plant';
      case 'pruning':
        return 'Prune Plant';
      default:
        return 'Care Reminder';
    }
  }

  // Create a copy with updated fields
  Reminder copyWith({
    String? id,
    String? userPlantId,
    String? reminderType,
    DateTime? scheduledFor,
    bool? isCompleted,
    DateTime? completedAt,
    bool? isRecurring,
    int? recurringDays,
  }) {
    return Reminder(
      id: id ?? this.id,
      userPlantId: userPlantId ?? this.userPlantId,
      reminderType: reminderType ?? this.reminderType,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringDays: recurringDays ?? this.recurringDays,
    );
  }
}
