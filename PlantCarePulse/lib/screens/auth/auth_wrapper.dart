import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/main_home_screen.dart';
import 'login_screen.dart';

/// Auth wrapper - checks if user is logged in
/// Shows login screen if not authenticated, home screen if authenticated
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Show home if user is logged in
        if (snapshot.hasData) {
          return const MainHomeScreen();
        }

        // Show login if user is not logged in
        return const LoginScreen();
      },
    );
  }
}
