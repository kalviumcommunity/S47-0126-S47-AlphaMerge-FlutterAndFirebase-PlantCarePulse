import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/info_card.dart';
import '../widgets/plant_care_card.dart';

/// A dedicated plant care screen that reuses custom widgets
/// in a different layout and context
class PlantCareScreen extends StatefulWidget {
  const PlantCareScreen({super.key});

  @override
  State<PlantCareScreen> createState() => _PlantCareScreenState();
}

class _PlantCareScreenState extends State<PlantCareScreen> {
  final List<Map<String, dynamic>> _plants = [
    {
      'name': 'Peace Lily',
      'care': 'Keep soil moist but not soggy. Prefers low to medium light.',
      'isLiked': false,
    },
    {
      'name': 'Rubber Plant',
      'care': 'Water when soil is dry. Bright, indirect light is ideal.',
      'isLiked': true,
    },
    {
      'name': 'Pothos',
      'care': 'Very easy to care for. Can grow in water or soil.',
      'isLiked': false,
    },
  ];

  void _togglePlantLike(int index, bool isLiked) {
    setState(() {
      _plants[index]['isLiked'] = isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Care Center'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add new plant feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with action buttons
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.green[700]!, Colors.green[500]!],
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.eco,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your Plant Collection',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_plants.length} plants in your care',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Reusing CustomButton widgets with different configurations
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'Care Tips',
                          onPressed: () {
                            _showCareDialog(context);
                          },
                          color: Colors.white,
                          textColor: Colors.green[700]!,
                          icon: Icons.lightbulb,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          label: 'Schedule',
                          onPressed: () {
                            _showScheduleDialog(context);
                          },
                          color: Colors.orange,
                          icon: Icons.schedule,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Quick Actions using InfoCard widgets
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Reusing InfoCard widgets in a different context
                  InfoCard(
                    title: 'Water Plants',
                    subtitle: 'Check which plants need watering today',
                    icon: Icons.water_drop,
                    iconColor: Colors.blue,
                    margin: const EdgeInsets.only(bottom: 8),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Checking watering schedule...')),
                      );
                    },
                  ),
                  InfoCard(
                    title: 'Plant Health Check',
                    subtitle: 'Monitor your plants for any issues',
                    icon: Icons.health_and_safety,
                    iconColor: Colors.red,
                    margin: const EdgeInsets.only(bottom: 8),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Running health diagnostics...')),
                      );
                    },
                  ),
                  InfoCard(
                    title: 'Growth Tracker',
                    subtitle: 'Log your plants\' growth progress',
                    icon: Icons.trending_up,
                    iconColor: Colors.green,
                    margin: const EdgeInsets.only(bottom: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening growth tracker...')),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Plant Collection using PlantCareCard widgets
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Plants',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Reusing PlantCareCard widgets with dynamic data
                  ...List.generate(_plants.length, (index) {
                    final plant = _plants[index];
                    return PlantCareCard(
                      plantName: plant['name'],
                      careInstructions: plant['care'],
                      imageUrl: '',
                      isLiked: plant['isLiked'],
                      onLikeChanged: (isLiked) => _togglePlantLike(index, isLiked),
                      onTap: () {
                        _showPlantDetails(context, plant['name']);
                      },
                    );
                  }),
                ],
              ),
            ),

            // Bottom action section
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                label: 'Add New Plant',
                onPressed: () {
                  _showAddPlantDialog(context);
                },
                color: Colors.green[600]!,
                icon: Icons.add_circle,
                width: double.infinity,
                height: 56,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Plant Care Tips'),
        content: const Text(
          '• Check soil moisture regularly\n'
          '• Provide adequate light\n'
          '• Maintain proper humidity\n'
          '• Remove dead leaves promptly\n'
          '• Fertilize during growing season',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Watering Schedule'),
        content: const Text(
          'Today\'s Tasks:\n'
          '• Water Peace Lily\n'
          '• Mist Rubber Plant\n'
          '• Check Pothos soil\n\n'
          'Tomorrow:\n'
          '• Fertilize Snake Plant',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPlantDetails(BuildContext context, String plantName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(plantName),
        content: Text('Detailed information about $plantName would be shown here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddPlantDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Plant'),
        content: const Text('Plant addition form would be shown here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}