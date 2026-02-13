import 'package:flutter/material.dart';
import '../plants/plant_library_screen.dart';
import '../plants/my_plants_screen.dart';
import '../profile/profile_screen.dart';

// Main home screen with bottom navigation - demonstrates StatefulWidget in real use
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const PlantLibraryScreen(),
    const MyPlantsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.yard),
            label: 'My Plants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Home tab content - demonstrates composition of widgets
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Care Pulse'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        actions: [
          // Animated notification button
          AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No new notifications')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome banner with gradient - Responsive
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(screenWidth * 0.04),
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C853), Color(0xFF00E676)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00C853).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isTablet ? 16 : 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '🌱',
                          style: TextStyle(fontSize: isTablet ? 40 : 32),
                        ),
                      ),
                      SizedBox(width: isTablet ? 20 : 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back!',
                              style: TextStyle(
                                fontSize: isTablet ? 32 : 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your plants are thriving',
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Quick actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.add_circle,
                          title: 'Add Plant',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/add-plant');
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.water_drop,
                          title: 'Schedule',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00B0FF), Color(0xFF40C4FF)],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/care-schedule');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Firestore Demo Button
                  SizedBox(
                    width: double.infinity,
                    child: _QuickActionCard(
                      icon: Icons.cloud_outlined,
                      title: 'Firestore Read Operations Demo',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6F00), Color(0xFFFFB300)],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/firestore-demo');
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Firebase Storage Demo Button
                  SizedBox(
                    width: double.infinity,
                    child: _QuickActionCard(
                      icon: Icons.cloud_upload,
                      title: 'Firebase Storage Upload Demo',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/storage-demo');
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Today's tasks
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Care Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _TaskCard(
                    plantName: 'Monstera "Monty"',
                    task: 'Needs watering',
                    icon: Icons.water_drop,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _TaskCard(
                    plantName: 'Peace Lily "Lily"',
                    task: 'Check soil moisture',
                    icon: Icons.touch_app,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

            // Plant care tips
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Care Tips',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _TipCard(
                    tip: 'Most houseplants prefer indirect sunlight',
                    icon: '☀️',
                  ),
                  const SizedBox(height: 12),
                  _TipCard(
                    tip: 'Overwatering is the #1 cause of plant death',
                    icon: '💧',
                  ),
                ],
              ),
            ),

            // Asset demonstration - Image.asset and Icons
            Padding(
              padding: const EdgeInsets.all(16),
              child: _AssetDemoCard(isTablet: isTablet),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00C853).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-plant');
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add, size: 28),
          ),
        ),
      ),
    );
  }
}

// Reusable quick action card widget with gradient and animation
class _QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Gradient gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: AnimatedOpacity(
        opacity: _isPressed ? 0.8 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.colors.first.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(widget.icon, size: 40, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Task card widget
class _TaskCard extends StatelessWidget {
  final String plantName;
  final String task;
  final IconData icon;
  final Color color;

  const _TaskCard({
    required this.plantName,
    required this.task,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          plantName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(task),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigate to plant detail
        },
      ),
    );
  }
}

// Tip card widget
class _TipCard extends StatelessWidget {
  final String tip;
  final String icon;

  const _TipCard({
    required this.tip,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                tip,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Asset demonstration card - Shows Image.asset and Icon usage
class _AssetDemoCard extends StatelessWidget {
  final bool isTablet;

  const _AssetDemoCard({this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with icon
            Row(
              children: [
                Icon(
                  Icons.image,
                  color: Colors.green[700],
                  size: isTablet ? 28 : 24,
                ),
                SizedBox(width: isTablet ? 12 : 8),
                Text(
                  'Assets & Icons Demo',
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 20 : 16),

            // Image.asset demonstration with fallback
            Container(
              width: double.infinity,
              height: isTablet ? 200 : 150,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _buildImageOrPlaceholder(isTablet),
            ),
            SizedBox(height: isTablet ? 20 : 16),

            // Flutter icons showcase
            Text(
              'Built-in Flutter Icons:',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Wrap(
              spacing: isTablet ? 16 : 12,
              runSpacing: isTablet ? 16 : 12,
              children: [
                _IconChip(
                  icon: Icons.flutter_dash,
                  label: 'Flutter',
                  color: Colors.blue,
                  isTablet: isTablet,
                ),
                _IconChip(
                  icon: Icons.android,
                  label: 'Android',
                  color: Colors.green,
                  isTablet: isTablet,
                ),
                _IconChip(
                  icon: Icons.apple,
                  label: 'iOS',
                  color: Colors.grey,
                  isTablet: isTablet,
                ),
                _IconChip(
                  icon: Icons.web,
                  label: 'Web',
                  color: Colors.purple,
                  isTablet: isTablet,
                ),
                _IconChip(
                  icon: Icons.desktop_windows,
                  label: 'Desktop',
                  color: Colors.orange,
                  isTablet: isTablet,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOrPlaceholder(bool isTablet) {
    // Load the logo image from assets
    return Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback if image fails to load
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF00C853).withOpacity(0.1),
                const Color(0xFF69F0AE).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '🌿',
                  style: TextStyle(fontSize: isTablet ? 80 : 60),
                ),
                SizedBox(height: isTablet ? 16 : 12),
                Text(
                  'PlantCare Pulse',
                  style: TextStyle(
                    color: const Color(0xFF00C853),
                    fontSize: isTablet ? 24 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder(bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: isTablet ? 60 : 48,
            color: Colors.grey[400],
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            'Add logo.png to assets/images/',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isTablet ? 14 : 12,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isTablet ? 8 : 4),
          Text(
            'Image.asset() ready to use',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: isTablet ? 12 : 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// Icon chip widget for showcasing Flutter icons
class _IconChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isTablet;

  const _IconChip({
    required this.icon,
    required this.label,
    required this.color,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: isTablet ? 24 : 20,
          ),
          SizedBox(width: isTablet ? 8 : 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: isTablet ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }
}
