import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/info_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[600]!],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.home,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome to Home Screen!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'This is the starting point of our navigation demo using custom widgets.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Navigation Cards using InfoCard widget
            InfoCard(
              title: 'Second Screen',
              subtitle: 'Navigate to the second screen of the app',
              icon: Icons.arrow_forward,
              iconColor: Colors.blue,
              onTap: () {
                Navigator.pushNamed(context, '/second');
              },
            ),
            InfoCard(
              title: 'Custom Widgets Demo',
              subtitle: 'Explore all our reusable custom widgets',
              icon: Icons.widgets,
              iconColor: Colors.green,
              onTap: () {
                Navigator.pushNamed(context, '/custom-widgets');
              },
            ),
            InfoCard(
              title: 'Plant Care Center',
              subtitle: 'Manage your plant collection with custom widgets',
              icon: Icons.local_florist,
              iconColor: Colors.teal,
              onTap: () {
                Navigator.pushNamed(context, '/plant-care');
              },
            ),
            const SizedBox(height: 24),

            // Action Buttons using CustomButton widget
            CustomButton(
              label: 'Go to Second Screen',
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              color: Colors.blue,
              icon: Icons.navigate_next,
              width: double.infinity,
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Go to Second Screen (with message)',
              onPressed: () {
                Navigator.pushNamed(
                  context, 
                  '/second', 
                  arguments: 'Hello from Home Screen! 👋'
                );
              },
              color: Colors.green,
              icon: Icons.message,
              width: double.infinity,
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Explore Custom Widgets',
              onPressed: () {
                Navigator.pushNamed(context, '/custom-widgets');
              },
              color: Colors.purple,
              icon: Icons.explore,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}