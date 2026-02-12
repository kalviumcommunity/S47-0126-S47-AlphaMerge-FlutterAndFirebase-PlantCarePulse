import 'package:cloud_firestore/cloud_firestore.dart';

/// User Model
/// Represents a user profile in the application
class UserModel {
  final String userId;
  final String name;
  final String email;
  final String? photoUrl;
  final int plantCount;
  final int daysActive;
  final UserPreferences preferences;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.photoUrl,
    this.plantCount = 0,
    this.daysActive = 0,
    required this.preferences,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
  });

  // Convert User to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'plantCount': plantCount,
      'daysActive': daysActive,
      'preferences': preferences.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }

  // Create User from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      userId: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      plantCount: map['plantCount'] ?? 0,
      daysActive: map['daysActive'] ?? 0,
      preferences: UserPreferences.fromMap(map['preferences'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      lastLoginAt: map['lastLoginAt'] != null 
          ? (map['lastLoginAt'] as Timestamp).toDate() 
          : null,
    );
  }

  // Create User from Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data, doc.id);
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? photoUrl,
    int? plantCount,
    int? daysActive,
    UserPreferences? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      plantCount: plantCount ?? this.plantCount,
      daysActive: daysActive ?? this.daysActive,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}

/// User Preferences Model
/// Represents user preferences and settings
class UserPreferences {
  final bool notificationsEnabled;
  final String reminderTime; // HH:mm format
  final String theme; // light/dark

  UserPreferences({
    this.notificationsEnabled = true,
    this.reminderTime = '09:00',
    this.theme = 'light',
  });

  // Convert UserPreferences to Map
  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'reminderTime': reminderTime,
      'theme': theme,
    };
  }

  // Create UserPreferences from Map
  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      reminderTime: map['reminderTime'] ?? '09:00',
      theme: map['theme'] ?? 'light',
    );
  }

  // Create a copy with updated fields
  UserPreferences copyWith({
    bool? notificationsEnabled,
    String? reminderTime,
    String? theme,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      theme: theme ?? this.theme,
    );
  }
}
