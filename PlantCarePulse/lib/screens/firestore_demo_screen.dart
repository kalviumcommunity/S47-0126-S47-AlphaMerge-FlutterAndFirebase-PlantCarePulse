import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/plant.dart';
import '../models/user_plant.dart';
import '../models/care_activity.dart';

/// Firestore Demo Screen
/// Demonstrates all Firestore read operations:
/// - StreamBuilder for real-time updates
/// - FutureBuilder for one-time reads
/// - Query filters
/// - Collection and document reads
class FirestoreDemoScreen extends StatefulWidget {
  const FirestoreDemoScreen({super.key});

  @override
  State<FirestoreDemoScreen> createState() => _FirestoreDemoScreenState();
}

class _FirestoreDemoScreenState extends State<FirestoreDemoScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'demo_user';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Read Operations'),
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 24),

          // Section 1: Real-time Plant Library (StreamBuilder)
          _buildSectionTitle('1. Real-Time Plant Library (StreamBuilder)'),
          _buildCategoryFilter(),
          const SizedBox(height: 12),
          _buildPlantLibraryStream(),
          const SizedBox(height: 32),

          // Section 2: User Statistics (FutureBuilder)
          _buildSectionTitle('2. User Statistics (FutureBuilder)'),
          _buildUserStatistics(userId),
          const SizedBox(height: 32),

          // Section 3: My Plants with Filter (StreamBuilder + Query)
          _buildSectionTitle('3. My Plants - Real-Time (StreamBuilder)'),
          _buildMyPlantsStream(userId),
          const SizedBox(height: 32),

          // Section 4: Plants Needing Water (StreamBuilder + Filter)
          _buildSectionTitle('4. Plants Needing Water (Filtered Stream)'),
          _buildPlantsNeedingWaterStream(userId),
          const SizedBox(height: 32),

          // Section 5: Recent Care Activities (StreamBuilder)
          _buildSectionTitle('5. Recent Care Activities (StreamBuilder)'),
          _buildRecentActivitiesStream(userId),
          const SizedBox(height: 32),

          // Section 6: Single Document Read (FutureBuilder)
          _buildSectionTitle('6. Single Plant Details (FutureBuilder)'),
          _buildSinglePlantRead(),
          const SizedBox(height: 32),

          // Initialize Sample Data Button
          _buildInitializeDataButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Firestore Read Operations Demo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'This screen demonstrates:\n'
              '• StreamBuilder for real-time updates\n'
              '• FutureBuilder for one-time reads\n'
              '• Query filters (where, orderBy)\n'
              '• Collection and document reads',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B5E20),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All', _selectedCategory == 'All', () {
            setState(() => _selectedCategory = 'All');
          }),
          _buildFilterChip('Indoor', _selectedCategory == 'Indoor', () {
            setState(() => _selectedCategory = 'Indoor');
          }),
          _buildFilterChip('Succulent', _selectedCategory == 'Succulent', () {
            setState(() => _selectedCategory = 'Succulent');
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: Colors.green.shade100,
        checkmarkColor: Colors.green.shade700,
      ),
    );
  }

  // StreamBuilder Example: Real-time plant library
  Widget _buildPlantLibraryStream() {
    return StreamBuilder<List<Plant>>(
      stream: _selectedCategory == 'All'
          ? _firestoreService.getPlantsStream()
          : _firestoreService.getPlantsByCategoryStream(_selectedCategory),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red.shade900),
              ),
            ),
          );
        }

        // No data state
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.eco_outlined, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'No plants available',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Click "Initialize Sample Data" below',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          );
        }

        // Data available
        final plants = snapshot.data!;
        return Card(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stream, size: 20, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      '${plants.length} plants (Live Updates)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: plants.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final plant = plants[index];
                  return ListTile(
                    leading: Text(plant.imageEmoji, style: const TextStyle(fontSize: 32)),
                    title: Text(plant.name),
                    subtitle: Text('${plant.category} • ${plant.difficulty}'),
                    trailing: Chip(
                      label: Text('${plant.wateringFrequencyDays}d'),
                      backgroundColor: Colors.blue.shade50,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // FutureBuilder Example: User statistics
  Widget _buildUserStatistics(String userId) {
    return FutureBuilder<Map<String, int>>(
      future: _firestoreService.getUserStatistics(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final stats = snapshot.data ?? {};
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.analytics_outlined, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      'Your Statistics (One-time Read)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('🌱', 'Total Plants', stats['totalPlants'] ?? 0),
                    _buildStatItem('💧', 'Need Water', stats['plantsNeedingWater'] ?? 0),
                    _buildStatItem('✅', 'Healthy', stats['healthyPlants'] ?? 0),
                    _buildStatItem('📊', 'Activities', stats['totalActivities'] ?? 0),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String emoji, String label, int value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // StreamBuilder Example: User's plants
  Widget _buildMyPlantsStream(String userId) {
    return StreamBuilder<List<UserPlant>>(
      stream: _firestoreService.getUserPlantsStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.yard_outlined, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'No plants in your collection',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          );
        }

        final userPlants = snapshot.data!;
        return Card(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stream, size: 20, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      '${userPlants.length} plants (Live)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userPlants.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final userPlant = userPlants[index];
                  return ListTile(
                    leading: Text(
                      userPlant.plant.imageEmoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    title: Text(userPlant.nickname),
                    subtitle: Text('${userPlant.plant.name} • ${userPlant.location}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          userPlant.needsWatering ? Icons.water_drop : Icons.check_circle,
                          color: userPlant.needsWatering ? Colors.orange : Colors.green,
                          size: 20,
                        ),
                        Text(
                          userPlant.wateringStatus,
                          style: TextStyle(
                            fontSize: 10,
                            color: userPlant.needsWatering ? Colors.orange : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // StreamBuilder with Filter: Plants needing water
  Widget _buildPlantsNeedingWaterStream(String userId) {
    return StreamBuilder<List<UserPlant>>(
      stream: _firestoreService.getPlantsNeedingWaterStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'All plants are well watered! 🎉',
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final plantsNeedingWater = snapshot.data!;
        return Card(
          color: Colors.orange.shade50,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.water_drop, size: 20, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      '${plantsNeedingWater.length} plants need water!',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: plantsNeedingWater.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final userPlant = plantsNeedingWater[index];
                  return ListTile(
                    leading: Text(
                      userPlant.plant.imageEmoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    title: Text(userPlant.nickname),
                    subtitle: Text(userPlant.wateringStatus),
                    trailing: const Icon(Icons.water_drop, color: Colors.orange),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // StreamBuilder: Recent activities
  Widget _buildRecentActivitiesStream(String userId) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestoreService.getRecentCareActivitiesStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.history, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'No care activities yet',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          );
        }

        final activities = snapshot.data!;
        return Card(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history, size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      '${activities.length} recent activities',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length > 5 ? 5 : activities.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final activityData = activities[index];
                  final activity = activityData['activity'] as CareActivity;
                  final plantNickname = activityData['plantNickname'] as String;

                  return ListTile(
                    leading: Text(activity.activityIcon, style: const TextStyle(fontSize: 24)),
                    title: Text(activity.activityDisplayName),
                    subtitle: Text(plantNickname),
                    trailing: Text(
                      _formatDate(activity.performedAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // FutureBuilder: Single document read
  Widget _buildSinglePlantRead() {
    return FutureBuilder<Plant?>(
      future: _firestoreService.getPlantById('1'), // Snake Plant
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Plant not found',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          );
        }

        final plant = snapshot.data!;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(plant.imageEmoji, style: const TextStyle(fontSize: 48)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            plant.scientificName,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(plant.description),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      label: Text(plant.category),
                      backgroundColor: Colors.green.shade50,
                    ),
                    Chip(
                      label: Text(plant.difficulty),
                      backgroundColor: Colors.blue.shade50,
                    ),
                    Chip(
                      label: Text('Water: ${plant.wateringFrequencyDays}d'),
                      backgroundColor: Colors.orange.shade50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInitializeDataButton() {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '⚠️ No data in Firestore?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Click below to add sample plants to your Firestore database',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Initializing sample data...')),
                );
                await _firestoreService.initializeSampleData();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sample data added! Check your Firestore console'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Initialize Sample Data'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
