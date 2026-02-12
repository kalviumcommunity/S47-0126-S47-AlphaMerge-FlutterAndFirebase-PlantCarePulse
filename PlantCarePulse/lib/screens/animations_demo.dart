import 'package:flutter/material.dart';

/// Main screen showcasing various animation types
class AnimationsDemo extends StatelessWidget {
  const AnimationsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animations & Transitions'),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildNavigationCard(
            context,
            'Implicit Animations',
            'AnimatedContainer, AnimatedOpacity, and more',
            Icons.animation,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ImplicitAnimationsDemo()),
            ),
          ),
          const SizedBox(height: 16),
          _buildNavigationCard(
            context,
            'Explicit Animations',
            'AnimationController with custom effects',
            Icons.control_camera,
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExplicitAnimationsDemo()),
            ),
          ),
          const SizedBox(height: 16),
          _buildNavigationCard(
            context,
            'Page Transitions',
            'Custom navigation animations',
            Icons.swap_horiz,
            Colors.orange,
            () => Navigator.push(
              context,
              _createSlideTransition(const PageTransitionsDemo()),
            ),
          ),
          const SizedBox(height: 16),
          _buildNavigationCard(
            context,
            'Plant Care Animations',
            'Animated plant care interactions',
            Icons.local_florist,
            Colors.teal,
            () => Navigator.push(
              context,
              _createFadeTransition(const PlantCareAnimations()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.purple[600]!],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.animation, size: 60, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Flutter Animations',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Explore implicit, explicit, and custom animations',
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }

  PageRouteBuilder _createSlideTransition(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }

  PageRouteBuilder _createFadeTransition(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

/// Implicit Animations Demo Screen
class ImplicitAnimationsDemo extends StatefulWidget {
  const ImplicitAnimationsDemo({super.key});

  @override
  State<ImplicitAnimationsDemo> createState() => _ImplicitAnimationsDemoState();
}

class _ImplicitAnimationsDemoState extends State<ImplicitAnimationsDemo> {
  bool _toggled = false;
  bool _visible = true;
  double _padding = 8.0;
  AlignmentGeometry _alignment = Alignment.topLeft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Animations'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('AnimatedContainer'),
            const Text(
              'Tap the box to see size and color changes',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _toggled = !_toggled;
                  });
                },
                child: AnimatedContainer(
                  width: _toggled ? 200 : 100,
                  height: _toggled ? 100 : 200,
                  decoration: BoxDecoration(
                    color: _toggled ? Colors.teal : Colors.orange,
                    borderRadius: BorderRadius.circular(_toggled ? 50 : 12),
                  ),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  child: const Center(
                    child: Text(
                      'Tap Me!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('AnimatedOpacity'),
            const Text(
              'Toggle visibility with fade effect',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Center(
              child: AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_florist,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: Text(_visible ? 'Hide' : 'Show'),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('AnimatedPadding'),
            const Text(
              'Watch the padding animate',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedPadding(
                padding: EdgeInsets.all(_padding),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Padded Box',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _padding = _padding == 8.0 ? 40.0 : 8.0;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Toggle Padding'),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('AnimatedAlign'),
            const Text(
              'Move the icon around',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedAlign(
                alignment: _alignment,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _alignment = _alignment == Alignment.topLeft
                      ? Alignment.bottomRight
                      : _alignment == Alignment.bottomRight
                          ? Alignment.topRight
                          : _alignment == Alignment.topRight
                              ? Alignment.bottomLeft
                              : Alignment.topLeft;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Move Icon'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Explicit Animations Demo Screen
class ExplicitAnimationsDemo extends StatefulWidget {
  const ExplicitAnimationsDemo({super.key});

  @override
  State<ExplicitAnimationsDemo> createState() => _ExplicitAnimationsDemoState();
}

class _ExplicitAnimationsDemoState extends State<ExplicitAnimationsDemo>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Rotation animation
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Slide animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explicit Animations'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('RotationTransition'),
            const Text(
              'Continuous rotation animation',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Center(
              child: RotationTransition(
                turns: _rotationController,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.refresh,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('ScaleTransition'),
            const Text(
              'Tap to scale up and down',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_scaleController.status == AnimationStatus.completed) {
                  _scaleController.reverse();
                } else {
                  _scaleController.forward();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Toggle Scale'),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('SlideTransition'),
            const Text(
              'Slide animation from left to right',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRect(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_florist,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_slideController.status == AnimationStatus.completed) {
                  _slideController.reverse();
                } else {
                  _slideController.forward();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Slide'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Page Transitions Demo
class PageTransitionsDemo extends StatelessWidget {
  const PageTransitionsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Transitions'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Try different page transition effects',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildTransitionButton(
            context,
            'Slide Transition',
            Colors.blue,
            Icons.arrow_forward,
            _createSlideTransition(const DemoPage(title: 'Slide Transition')),
          ),
          const SizedBox(height: 16),
          _buildTransitionButton(
            context,
            'Fade Transition',
            Colors.purple,
            Icons.blur_on,
            _createFadeTransition(const DemoPage(title: 'Fade Transition')),
          ),
          const SizedBox(height: 16),
          _buildTransitionButton(
            context,
            'Scale Transition',
            Colors.green,
            Icons.zoom_in,
            _createScaleTransition(const DemoPage(title: 'Scale Transition')),
          ),
          const SizedBox(height: 16),
          _buildTransitionButton(
            context,
            'Rotation Transition',
            Colors.orange,
            Icons.rotate_right,
            _createRotationTransition(const DemoPage(title: 'Rotation Transition')),
          ),
        ],
      ),
    );
  }

  Widget _buildTransitionButton(
    BuildContext context,
    String label,
    Color color,
    IconData icon,
    PageRouteBuilder route,
  ) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.push(context, route),
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }

  PageRouteBuilder _createSlideTransition(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }

  PageRouteBuilder _createFadeTransition(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  PageRouteBuilder _createScaleTransition(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );
      },
    );
  }

  PageRouteBuilder _createRotationTransition(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );
      },
    );
  }
}

/// Demo page for transitions
class DemoPage extends StatelessWidget {
  final String title;

  const DemoPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.teal),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Animation completed successfully!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Plant Care Animations
class PlantCareAnimations extends StatefulWidget {
  const PlantCareAnimations({super.key});

  @override
  State<PlantCareAnimations> createState() => _PlantCareAnimationsState();
}

class _PlantCareAnimationsState extends State<PlantCareAnimations>
    with SingleTickerProviderStateMixin {
  bool _isWatered = false;
  bool _isFertilized = false;
  late AnimationController _growthController;
  late Animation<double> _growthAnimation;

  @override
  void initState() {
    super.initState();
    _growthController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _growthAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _growthController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _growthController.dispose();
    super.dispose();
  }

  void _waterPlant() {
    setState(() {
      _isWatered = true;
    });
    _growthController.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isWatered = false;
        });
      }
    });
  }

  void _fertilizePlant() {
    setState(() {
      _isFertilized = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isFertilized = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Care Animations'),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _growthAnimation,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _isWatered
                      ? Colors.blue[100]
                      : _isFertilized
                          ? Colors.green[100]
                          : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_florist,
                  size: 100,
                  color: _isWatered
                      ? Colors.blue
                      : _isFertilized
                          ? Colors.green
                          : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 32),
            AnimatedOpacity(
              opacity: _isWatered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: const Text(
                '💧 Plant is being watered!',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            AnimatedOpacity(
              opacity: _isFertilized ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: const Text(
                '🌱 Plant is being fertilized!',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _waterPlant,
                  icon: const Icon(Icons.water_drop),
                  label: const Text('Water'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _fertilizePlant,
                  icon: const Icon(Icons.eco),
                  label: const Text('Fertilize'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
