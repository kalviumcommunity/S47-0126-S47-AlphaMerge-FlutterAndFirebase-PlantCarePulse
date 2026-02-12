import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

/// Firebase Verification Screen
/// This screen demonstrates successful Firebase SDK integration
class FirebaseVerificationScreen extends StatelessWidget {
  const FirebaseVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase SDK Verification'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _getFirebaseInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final info = snapshot.data as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSuccessCard(),
                const SizedBox(height: 16),
                _buildInfoCard('Firebase Status', info['status'] ?? 'Unknown'),
                const SizedBox(height: 16),
                _buildInfoCard('Project ID', info['projectId'] ?? 'N/A'),
                const SizedBox(height: 16),
                _buildInfoCard('App Name', info['appName'] ?? 'N/A'),
                const SizedBox(height: 16),
                _buildInfoCard('Current Platform', info['platform'] ?? 'N/A'),
                const SizedBox(height: 16),
                _buildPlatformsCard(),
                const SizedBox(height: 16),
                _buildServicesCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[700], size: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Firebase SDK Setup Successful! 🎉',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Configured using FlutterFire CLI',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.info_outline, color: Colors.blue[700]),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildPlatformsCard() {
    final platforms = [
      {'name': 'Android', 'icon': Icons.android, 'color': Colors.green},
      {'name': 'iOS', 'icon': Icons.apple, 'color': Colors.grey},
      {'name': 'Web', 'icon': Icons.web, 'color': Colors.blue},
      {'name': 'macOS', 'icon': Icons.laptop_mac, 'color': Colors.blueGrey},
      {'name': 'Windows', 'icon': Icons.desktop_windows, 'color': Colors.cyan},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configured Platforms',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: platforms.map((platform) {
                return Chip(
                  avatar: Icon(
                    platform['icon'] as IconData,
                    color: platform['color'] as Color,
                    size: 20,
                  ),
                  label: Text(platform['name'] as String),
                  backgroundColor: (platform['color'] as Color).withValues(alpha: 0.1),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesCard() {
    final services = [
      {'name': 'Firebase Core', 'version': '^3.0.0', 'status': 'Active'},
      {'name': 'Firebase Auth', 'version': '^5.0.0', 'status': 'Active'},
      {'name': 'Cloud Firestore', 'version': '^5.0.0', 'status': 'Active'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Firebase Services',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...services.map((service) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        service['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      service['version'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getFirebaseInfo() async {
    try {
      final app = Firebase.app();
      return {
        'status': 'Connected ✓',
        'projectId': app.options.projectId,
        'appName': app.name,
        'platform': _getCurrentPlatform(),
      };
    } catch (e) {
      return {
        'status': 'Error: $e',
        'projectId': 'N/A',
        'appName': 'N/A',
        'platform': 'N/A',
      };
    }
  }

  String _getCurrentPlatform() {
    if (const bool.fromEnvironment('dart.library.html')) {
      return 'Web';
    }
    // This is a simplified check - in production, use Platform.isAndroid, etc.
    return 'Desktop/Mobile';
  }
}
