import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/info_card.dart';
import '../widgets/like_button.dart';
import '../widgets/plant_care_card.dart';

/// Demo screen showcasing all custom reusable widgets
class CustomWidgetsDemo extends StatefulWidget {
  const CustomWidgetsDemo({super.key});

  @override
  State<CustomWidgetsDemo> createState() => _CustomWidgetsDemoState();
}

class _CustomWidgetsDemoState extends State<CustomWidgetsDemo> {
  int _likeCount = 0;

  void _onLikeChanged(bool isLiked) {
    setState(() {
      if (isLiked) {
        _likeCount++;
      } else {
        _likeCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Widgets Demo'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.green[600]!],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.widgets,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Reusable Custom Widgets',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Likes: $_likeCount',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Custom Buttons Section
            const Text(
              'Custom Buttons',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'Primary',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Primary button pressed!')),
                      );
                    },
                    color: Colors.green,
                    icon: Icons.check,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    label: 'Secondary',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Secondary button pressed!')),
                      );
                    },
                    color: Colors.orange,
                    icon: Icons.star,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Navigate to Plant Care',
              onPressed: () {
                Navigator.pushNamed(context, '/plant-care');
              },
              color: Colors.teal,
              icon: Icons.local_florist,
              width: double.infinity,
            ),
            const SizedBox(height: 24),

            // Info Cards Section
            const Text(
              'Info Cards',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            InfoCard(
              title: 'Plant Care Tips',
              subtitle: 'Learn how to take care of your plants effectively',
              icon: Icons.local_florist,
              iconColor: Colors.green,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Plant Care Tips tapped!')),
                );
              },
            ),
            InfoCard(
              title: 'Watering Schedule',
              subtitle: 'Set up automated watering reminders',
              icon: Icons.water_drop,
              iconColor: Colors.blue,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Watering Schedule tapped!')),
                );
              },
            ),
            InfoCard(
              title: 'Plant Health Monitor',
              subtitle: 'Track your plant\'s health and growth progress',
              icon: Icons.health_and_safety,
              iconColor: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Health Monitor tapped!')),
                );
              },
            ),
            const SizedBox(height: 24),

            // Like Buttons Section
            const Text(
              'Interactive Like Buttons',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    LikeButton(
                      onLikeChanged: _onLikeChanged,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text('Default'),
                  ],
                ),
                Column(
                  children: [
                    LikeButton(
                      onLikeChanged: _onLikeChanged,
                      likedColor: Colors.purple,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text('Purple'),
                  ],
                ),
                Column(
                  children: [
                    LikeButton(
                      onLikeChanged: _onLikeChanged,
                      likedColor: Colors.orange,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text('Orange'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Plant Care Cards Section
            const Text(
              'Plant Care Cards',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            PlantCareCard(
              plantName: 'Monstera Deliciosa',
              careInstructions: 'Keep in bright, indirect light. Water when top inch of soil is dry. Loves humidity and regular misting.',
              imageUrl: '',
              onLikeChanged: _onLikeChanged,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Monstera card tapped!')),
                );
              },
            ),
            PlantCareCard(
              plantName: 'Snake Plant',
              careInstructions: 'Very low maintenance. Can tolerate low light and infrequent watering. Perfect for beginners.',
              imageUrl: '',
              onLikeChanged: _onLikeChanged,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Snake Plant card tapped!')),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}