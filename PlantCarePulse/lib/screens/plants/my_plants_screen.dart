import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_plant.dart';
import '../../services/firestore_service.dart';
import 'user_plant_detail_screen.dart';

// My Plants screen - demonstrates Firestore real-time data with StreamBuilder
class MyPlantsScreen extends StatefulWidget {
  const MyPlantsScreen({super.key});

  @override
  State<MyPlantsScreen> createState() => _MyPlantsScreenState();
}

class _MyPlantsScreenState extends State<MyPlantsScreen> {
  final _firestoreService = FirestoreService();

  Future<void> _waterPlant(UserPlant plant) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestoreService.waterPlant(plant.id, user.uid);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${plant.nickname} has been watered! 💧'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to water plant: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToPlantDetail(UserPlant plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPlantDetailScreen(userPlant: plant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Plants')),
        body: const Center(
          child: Text('Please log in to view your plants'),
        ),
      );
    }

    // MediaQuery for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Plants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/add-plant');
              // Refresh is automatic with StreamBuilder
            },
          ),
        ],
      ),
      body: StreamBuilder<List<UserPlant>>(
        stream: _firestoreService.getUserPlants(user.uid),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading plants',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final myPlants = snapshot.data ?? [];

          // Empty state
          if (myPlants.isEmpty) {
            return _buildEmptyState();
          }

          final plantsNeedingWater = myPlants.where((p) => p.needsWatering).toList();

          return Column(
            children: [
              // Alert banner if plants need water
              if (plantsNeedingWater.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isTablet ? 20 : 16),
                  color: Colors.orange[100],
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Colors.orange[800],
                        size: isTablet ? 28 : 24,
                      ),
                      SizedBox(width: isTablet ? 16 : 12),
                      Expanded(
                        child: Text(
                          '${plantsNeedingWater.length} plant(s) need watering!',
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 18 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Plant list/grid - Responsive
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (isTablet) {
                      // Tablet: Grid view
                      return GridView.builder(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth < 900 ? 2 : 3,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: myPlants.length,
                        itemBuilder: (context, index) {
                          final userPlant = myPlants[index];
                          return _MyPlantCard(
                            userPlant: userPlant,
                            onWater: () => _waterPlant(userPlant),
                            onTap: () => _navigateToPlantDetail(userPlant),
                            isTablet: isTablet,
                          );
                        },
                      );
                    } else {
                      // Mobile: List view
                      return ListView.builder(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        itemCount: myPlants.length,
                        itemBuilder: (context, index) {
                          final userPlant = myPlants[index];
                          return _MyPlantCard(
                            userPlant: userPlant,
                            onWater: () => _waterPlant(userPlant),
                            onTap: () => _navigateToPlantDetail(userPlant),
                            isTablet: isTablet,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
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

// My plant card widget - demonstrates interactive widget with Firestore data
class _MyPlantCard extends StatelessWidget {
  final UserPlant userPlant;
  final VoidCallback onWater;
  final VoidCallback onTap;
  final bool isTablet;

  const _MyPlantCard({
    required this.userPlant,
    required this.onWater,
    required this.onTap,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final needsWater = userPlant.needsWatering;

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: isTablet ? 0 : 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Plant emoji
                  Container(
                    width: isTablet ? 80 : 60,
                    height: isTablet ? 80 : 60,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        userPlant.plant.imageEmoji,
                        style: TextStyle(fontSize: isTablet ? 40 : 32),
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 20 : 16),

                  // Plant info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userPlant.nickname,
                          style: TextStyle(
                            fontSize: isTablet ? 22 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userPlant.plant.name,
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: needsWater ? Colors.orange[100] : Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: onWater,
                      icon: Icon(
                        Icons.water_drop,
                        color: needsWater ? Colors.orange : Colors.blue,
                      ),
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
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
