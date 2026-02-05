import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/info_card.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments passed from the previous screen
    final message = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
        backgroundColor: Colors.purple,
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
                  colors: [Colors.purple[400]!, Colors.purple[600]!],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.star,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome to Second Screen!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'You have successfully navigated to this screen using custom widgets.',
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

            // Display message if passed from previous screen
            if (message != null) ...[
              InfoCard(
                title: 'Message Received',
                subtitle: message,
                icon: Icons.message,
                iconColor: Colors.purple,
                cardColor: Colors.purple.shade50,
              ),
              const SizedBox(height: 16),
            ],

            // Navigation Options using InfoCard
            InfoCard(
              title: 'Third Screen',
              subtitle: 'Continue to the next screen in the navigation flow',
              icon: Icons.arrow_forward,
              iconColor: Colors.orange,
              onTap: () {
                Navigator.pushNamed(context, '/third');
              },
            ),
            InfoCard(
              title: 'Custom Widgets Demo',
              subtitle: 'See all custom widgets in action',
              icon: Icons.widgets,
              iconColor: Colors.green,
              onTap: () {
                Navigator.pushNamed(context, '/custom-widgets');
              },
            ),
            InfoCard(
              title: 'Plant Care Center',
              subtitle: 'Explore plant care features with custom widgets',
              icon: Icons.local_florist,
              iconColor: Colors.teal,
              onTap: () {
                Navigator.pushNamed(context, '/plant-care');
              },
            ),
            const SizedBox(height: 24),

            // Action Buttons using CustomButton
            CustomButton(
              label: 'Back to Home',
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.purple,
              icon: Icons.home,
              width: double.infinity,
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Go to Third Screen',
              onPressed: () {
                Navigator.pushNamed(context, '/third');
              },
              color: Colors.orange,
              icon: Icons.navigate_next,
              width: double.infinity,
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Explore Widgets',
              onPressed: () {
                Navigator.pushNamed(context, '/custom-widgets');
              },
              color: Colors.green,
              icon: Icons.explore,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}