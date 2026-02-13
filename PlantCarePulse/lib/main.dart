import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import all screens
import 'screens/home/main_home_screen.dart';
import 'screens/plants/plant_library_screen.dart';
import 'screens/plants/my_plants_screen.dart';
import 'screens/plants/add_plant_screen.dart';
import 'screens/plants/plant_detail_screen.dart';
import 'screens/care/care_schedule_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/auth_wrapper.dart';
import 'screens/firestore_demo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PlantCarePulseApp());
}

/// Main application widget
/// This is the root of the Plant Care Pulse application
class PlantCarePulseApp extends StatelessWidget {
  const PlantCarePulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App configuration
      title: 'Plant Care Pulse',
      debugShowCheckedModeBanner: false,
      
      // Modern vibrant theme with gradients
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C853), // Vibrant green
          brightness: Brightness.light,
          primary: const Color(0xFF00C853),
          secondary: const Color(0xFF69F0AE),
          tertiary: const Color(0xFF00E676),
          surface: Colors.white,
          background: const Color(0xFFF8FFF9),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FFF9),
        
        // Modern AppBar with gradient
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1B5E20),
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1B5E20),
            letterSpacing: -0.5,
          ),
        ),
        
        // Elevated cards with subtle shadows
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          shadowColor: const Color(0xFF00C853).withOpacity(0.1),
        ),
        
        // Modern input fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF00C853), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFFF5252), width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFFF5252), width: 2),
          ),
        ),
        
        // Vibrant buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: const Color(0xFF00C853),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // Floating Action Button
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00C853),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        
        // Bottom Navigation Bar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF00C853),
          unselectedItemColor: Color(0xFF9E9E9E),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        
        // Text theme
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1B5E20),
            letterSpacing: -1,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B5E20),
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B5E20),
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF424242),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF616161),
          ),
        ),
      ),
      
      // Initial route - check auth state
      home: const AuthWrapper(),
      
      // Route definitions
      // All app navigation is defined here
      routes: {
        // Authentication screens
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        
        // Main home screen with bottom navigation
        '/home': (context) => const MainHomeScreen(),
        
        // Plant-related screens
        '/plant-library': (context) => const PlantLibraryScreen(),
        '/my-plants': (context) => const MyPlantsScreen(),
        '/add-plant': (context) => const AddPlantScreen(),
        '/plant-detail': (context) => const PlantDetailScreen(),
        
        // Care schedule screen
        '/care-schedule': (context) => const CareScheduleScreen(),
        
        // Profile screen
        '/profile': (context) => const ProfileScreen(),
        
        // Firestore demo screen
        '/firestore-demo': (context) => const FirestoreDemoScreen(),
      },
    );
  }
}
