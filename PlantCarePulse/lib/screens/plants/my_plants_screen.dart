import 'package:flutter/material.dart';
import '../../models/plant.dart';
import '../../models/user_plant.dart';

// My Plants screen - demonstrates state management with user's plant collection
class MyPlantsScreen extends StatefulWidget {
  const MyPlantsScreen({super.key});

  @override
  State<MyPlantsScreen> createState() => _MyPlantsScreenState();
}

class _MyPlantsScreenState extends State<MyPlantsScreen> {
  // Sample user plants - in real app, this would come from database
  late List<UserPlant> _myPlants;

  @override
  void initState() {
    super.initState();
    _initializeSamplePlants();
  }

  void _initializeSamplePlants() {
    final plants = Plant.getSamplePlants();
    _myPlants = [
      UserPlant(
        id: '1',
        plant: plants[1], // Monstera
        nickname: 'Monty',
        dateAdded: DateTime.now().subtract(const Duration(days: 30)),
        lastWatered: DateTime.now().subtract(const Duration(days: 5)),
        location: 'Living Room',
        notes: 'Growing beautifully!',
      ),
      UserPlant(
        id: '2',
        plant: plants[3], // Peace Lily
        nickname: 'Lily',
        dateAdded: DateTime.now().subtract(const Duration(days: 60)),
        lastWatered: DateTime.now().subtract(const Duration(days: 3)),
        location: 'Bedroom',
        notes: 'Loves the humidity',
      ),
      UserPlant(
        id: '3',
        plant: plants[0], // Snake Plant
        nickname: 'Snakey',
        dateAdded: DateTime.now().subtract(const Duration(days: 90)),
        lastWatered: DateTime.now().subtract(const Duration(days: 10)),
        location: 'Office',
        notes: 'Very low maintenance',
      ),
    ];
  }

  void _waterPlant(UserPlant plant) {
    setState(() {
      plant.water();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${plant.nickname} has been watered! 💧'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plantsNeedingWater = _myPlants.where((p) => p.needsWatering).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Plants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-plant');
            },
          ),
        ],
      ),
      body: _myPlants.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // Alert banner if plants need water
                if (plantsNeedingWater.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.orange[100],
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.orange[800]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${plantsNeedingWater.length} plant(s) need watering!',
                            style: TextStyle(
                              color: Colors.orange[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Plant list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _myPlants.length,
                    itemBuilder: (context, index) {
                      final userPlant = _myPlants[index];
                      return _MyPlantCard(
                        userPlant: userPlant,
                        onWater: () => _waterPlant(userPlant),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-plant');
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.yard_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No plants yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first plant to get started!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/add-plant');
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Plant'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// My plant card widget - demonstrates interactive stateless widget
class _MyPlantCard extends StatelessWidget {
  final UserPlant userPlant;
  final VoidCallback onWater;

  const _MyPlantCard({
    required this.userPlant,
    required this.onWater,
  });

  @override
  Widget build(BuildContext context) {
    final needsWater = userPlant.needsWatering;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Plant emoji
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      userPlant.plant.imageEmoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Plant info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userPlant.nickname,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userPlant.plant.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            userPlant.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Water button
                IconButton(
                  onPressed: onWater,
                  icon: Icon(
                    Icons.water_drop,
                    color: needsWater ? Colors.orange : Colors.blue,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: needsWater
                        ? Colors.orange[100]
                        : Colors.blue[50],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            // Watering status
            Row(
              children: [
                Icon(
                  needsWater ? Icons.warning_amber : Icons.check_circle,
                  size: 16,
                  color: needsWater ? Colors.orange : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  userPlant.wateringStatus,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: needsWater ? Colors.orange[800] : Colors.green[800],
                  ),
                ),
              ],
            ),

            if (userPlant.lastWatered != null) ...[
              const SizedBox(height: 4),
              Text(
                'Last watered: ${_formatDate(userPlant.lastWatered!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],

            if (userPlant.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.note, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        userPlant.notes,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    return '$difference days ago';
  }
}
