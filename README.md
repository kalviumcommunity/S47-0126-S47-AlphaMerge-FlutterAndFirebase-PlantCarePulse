# Plant Care Pulse - Flutter & Firebase Application

## 🌱 Project Overview

Plant Care Pulse is a comprehensive Flutter application integrated with Firebase services, demonstrating modern mobile development practices including authentication, cloud database, and multi-platform support.

---

## 🔥 Firebase Integration

This project uses **FlutterFire CLI** for seamless Firebase integration across all platforms.

### Configured Platforms:
- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Web
- ✅ Windows

### Active Firebase Services:
- 🔐 **Firebase Authentication** - Email/Password authentication
- 📊 **Cloud Firestore** - Real-time cloud database
- ⚙️ **Firebase Core** - Core Firebase SDK

### Firebase Project:
- **Project ID**: `plantcareplus-b64a2`
- **Project Name**: Plant Care Plus

---

## 🚀 Quick Start

### Prerequisites:
- Flutter SDK (3.38.8 or higher)
- Dart SDK
- Node.js and npm (for Firebase tools)

### Installation:

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd S47-0126-S47-AlphaMerge-FlutterAndFirebase-PlantCarePulse
   ```

2. **Navigate to Flutter project**:
   ```bash
   cd PlantCarePulse
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the app**:
   ```bash
   # For Web
   flutter run -d chrome
   
   # For Windows
   flutter run -d windows
   
   # For Android
   flutter run -d android
   ```

---

## 📱 Features

### Authentication
- User registration with email/password
- User login
- Password reset
- Secure logout
- Auth state management

### Plant Care Management
- Plant care tracking
- Watering schedules
- Plant information cards
- Custom widgets for plant display

### UI/UX Demonstrations
- Responsive design
- Widget tree examples
- Stateless vs Stateful widgets
- Multi-screen navigation
- Scrollable views
- User input forms
- State management patterns
- Custom widgets
- Animations and transitions

### Firebase Verification
- Real-time Firebase status
- Platform configuration display
- Service status monitoring

---

## 📁 Project Structure

```
PlantCarePulse/
├── lib/
│   ├── main.dart                      # App entry point with Firebase init
│   ├── firebase_options.dart          # Auto-generated Firebase config
│   ├── firebase_verification.dart     # Firebase status screen
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── auth_wrapper.dart      # Auth state wrapper
│   │   │   ├── login_screen.dart      # Login UI
│   │   │   └── signup_screen.dart     # Signup UI
│   │   ├── home_screen.dart
│   │   ├── plant_care_screen.dart
│   │   ├── animations_demo.dart
│   │   └── ... (other screens)
│   ├── services/
│   │   └── auth_service.dart          # Firebase Auth service
│   └── widgets/
│       ├── animated_plant_card.dart
│       ├── custom_button.dart
│       └── ... (other widgets)
├── android/                           # Android platform
├── ios/                              # iOS platform
├── web/                              # Web platform
├── windows/                          # Windows platform
├── macos/                            # macOS platform
└── pubspec.yaml                      # Dependencies
```

---

## 📚 Documentation

### Firebase Integration:
- **[FlutterFire CLI Integration Guide](FLUTTERFIRE_CLI_INTEGRATION.md)** - Complete setup guide

### Feature Documentation:
- **[Animations README](ANIMATIONS_README.md)** - Animation examples
- **[Custom Widgets README](CUSTOM_WIDGETS_README.md)** - Custom widget guide
- **[Firebase Auth README](FIREBASE_AUTH_README.md)** - Authentication guide
- **[Multi-Screen Navigation](MULTI_SCREEN_NAVIGATION_README.md)** - Navigation patterns
- **[Responsive Design](RESPONSIVE_DESIGN_README.md)** - Responsive UI guide
- **[Scrollable Views](SCROLLABLE_VIEWS_README.md)** - Scrollable widgets
- **[State Management](STATELESS_STATEFUL_README.md)** - State management
- **[User Input Forms](USER_INPUT_FORM_README.md)** - Form handling
- **[Widget Tree](WIDGET_TREE_README.md)** - Widget tree concepts

---

## 🛠️ Technologies Used

### Frontend:
- **Flutter** - UI framework
- **Dart** - Programming language
- **Material Design 3** - Design system

### Backend:
- **Firebase Authentication** - User management
- **Cloud Firestore** - NoSQL database
- **Firebase Core** - Core services

### Tools:
- **FlutterFire CLI** - Firebase configuration
- **Firebase Tools** - Firebase management
- **Git** - Version control

---

## 🔧 Development

### Run Tests:
```bash
flutter test
```

### Static Analysis:
```bash
flutter analyze
```

### Clean Build:
```bash
flutter clean
flutter pub get
```

### Update Dependencies:
```bash
flutter pub upgrade
```

---

## 🌐 Available Routes

| Route | Description |
|-------|-------------|
| `/` | Auth Wrapper (Login/Home) |
| `/login` | Login Screen |
| `/signup` | Signup Screen |
| `/home` | Main Home Screen |
| `/firebase-verification` | Firebase Status |
| `/responsive` | Responsive UI Demo |
| `/widget-tree` | Widget Tree Demo |
| `/stateless-stateful` | State Demo |
| `/navigation-home` | Navigation Demo |
| `/scrollable-views` | Scrollable Demo |
| `/user-input-form` | Form Demo |
| `/state-management` | State Management |
| `/custom-widgets` | Custom Widgets |
| `/plant-care` | Plant Care Center |
| `/animations` | Animations Demo |

---

## 🧪 Testing

### Manual Testing:
1. Launch the app
2. Test user registration
3. Test user login
4. Navigate through all screens
5. Test Firebase verification screen
6. Test logout functionality

### Automated Testing:
```bash
flutter test
```

Test files available in `test/` directory:
- `animations_test.dart`
- `custom_widgets_test.dart`
- `scrollable_views_test.dart`
- `user_input_form_test.dart`
- `widget_test.dart`

---

## 📊 Firebase Console

Access your Firebase project:
- **Console URL**: https://console.firebase.google.com/project/plantcareplus-b64a2
- **Authentication**: Email/Password enabled
- **Firestore**: Database in test mode
- **Platforms**: 5 platforms registered

---

## 🤝 Contributing

### Sprint-2 Task: Firebase SDK Integration
This implementation demonstrates:
- FlutterFire CLI usage
- Multi-platform Firebase configuration
- Firebase Authentication integration
- Cloud Firestore setup
- Comprehensive documentation

### Pull Request:
- **Title**: `[Sprint-2] Firebase SDK Integration with FlutterFire CLI – Plant Care Pulse Team`
- **Branch**: `sprint-2/firebase-cli-integration`

---

## 🐛 Troubleshooting

### Common Issues:

**Issue**: Firebase not initialized  
**Solution**: Ensure `Firebase.initializeApp()` is called in `main()`

**Issue**: Platform not supported  
**Solution**: Run `flutterfire configure` to add the platform

**Issue**: Dependencies conflict  
**Solution**: Run `flutter clean && flutter pub get`

**Issue**: Build fails  
**Solution**: Check `flutter doctor` for missing dependencies

---

## 📝 License

This project is part of an educational sprint demonstrating Flutter and Firebase integration.

---

## 👥 Team

**Project**: Plant Care Pulse  
**Sprint**: Sprint-2  
**Task**: Firebase SDK Integration with FlutterFire CLI

---

## 🎯 Learning Objectives Achieved

- ✅ Installed and configured FlutterFire CLI
- ✅ Integrated Firebase Core, Auth, and Firestore
- ✅ Configured multi-platform support (5 platforms)
- ✅ Implemented authentication flow
- ✅ Created verification and testing screens
- ✅ Documented the entire process
- ✅ Demonstrated CLI benefits over manual setup

---

## 🚀 Next Steps

1. Implement Firestore data models
2. Add real-time data synchronization
3. Implement offline persistence
4. Configure Firebase Security Rules
5. Add Firebase Analytics
6. Implement Cloud Messaging
7. Add Firebase Storage for images

---

## 📞 Support

For questions or issues:
1. Check the documentation files
2. Review the Quick Start Guide
3. Check Firebase Console
4. Refer to Flutter and Firebase documentation

---

## ⭐ Key Features

- 🔐 Secure authentication with Firebase
- 📱 Multi-platform support (5 platforms)
- 🎨 Modern Material Design 3 UI
- 🌱 Plant care management
- 📊 Real-time database with Firestore
- 🔄 State management examples
- 🎭 Animations and transitions
- 📝 Comprehensive documentation
- ✅ Production-ready code

---

**Built with ❤️ using Flutter and Firebase**

*Last Updated: February 10, 2026*
