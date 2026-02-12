/// Simple user service to store logged-in user data
/// In a real app, this would use shared_preferences or a state management solution
class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  String? _userName;
  String? _userEmail;

  void setUser(String name, String email) {
    _userName = name;
    _userEmail = email;
  }

  String get userName => _userName ?? 'Plant Lover';
  String get userEmail => _userEmail ?? 'user@example.com';

  void clearUser() {
    _userName = null;
    _userEmail = null;
  }
}
