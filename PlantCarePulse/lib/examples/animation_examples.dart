import 'package:flutter/material.dart';
import '../widgets/animated_plant_card.dart';

/// Example: Using animations in a plant list
class AnimatedPlantListExample extends StatelessWidget {
  const AnimatedPlantListExample({super.key});

  @override
  Widget build(BuildContext context) {
    final plants = [
      {
        'name': 'Monstera Deliciosa',
        'species': 'Swiss Cheese Plant',
        'schedule': 'Every 7 days',
        'icon': Icons.local_florist,
        'color': Colors.green,
      },
      {
        'name': 'Snake Plant',
        'species': 'Sansevieria',
        'schedule': 'Every 14 days',
        'icon': Icons.grass,
        'color': Colors.teal,
      },
      {
        'name': 'Pothos',
        'species': 'Epipremnum aureum',
        'schedule': 'Every 5 days',
        'icon': Icons.eco,
        'color': Colors.lightGreen,
      },
      {
        'name': 'Peace Lily',
        'species': 'Spathiphyllum',
        'schedule': 'Every 7 days',
        'icon': Icons.spa,
        'color': Colors.purple,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Plant Collection'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          
          // Staggered animation delay for each card
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 100)),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 50 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AnimatedPlantCard(
                plantName: plant['name'] as String,
                species: plant['species'] as String,
                wateringSchedule: plant['schedule'] as String,
                icon: plant['icon'] as IconData,
                color: plant['color'] as Color,
                onTap: () {
                  Navigator.push(
                    context,
                    _createSlideTransition(
                      PlantDetailExample(plantName: plant['name'] as String),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddPlantDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Plant'),
        backgroundColor: Colors.green[600],
      ),
    );
  }

  PageRouteBuilder _createSlideTransition(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
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

  void _showAddPlantDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Plant',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const AddPlantDialog();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}

/// Example: Plant detail screen with animations
class PlantDetailExample extends StatefulWidget {
  final String plantName;

  const PlantDetailExample({super.key, required this.plantName});

  @override
  State<PlantDetailExample> createState() => _PlantDetailExampleState();
}

class _PlantDetailExampleState extends State<PlantDetailExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isWatered = false;
  double _healthPercentage = 0.75;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _waterPlant() {
    setState(() {
      _isWatered = true;
      _healthPercentage = (_healthPercentage + 0.1).clamp(0.0, 1.0);
    });

    _controller.forward(from: 0.0);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isWatered = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plantName),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero animation for plant image
            Hero(
              tag: 'plant_${widget.plantName}',
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 250,
                decoration: BoxDecoration(
                  color: _isWatered ? Colors.blue[100] : Colors.green[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: AnimatedScale(
                    scale: _isWatered ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Icon(
                      Icons.local_florist,
                      size: 120,
                      color: _isWatered ? Colors.blue : Colors.green,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Animated health indicator
            AnimatedPlantHealth(
              healthPercentage: _healthPercentage,
              color: Colors.green,
              label: 'Plant Health',
            ),
            const SizedBox(height: 24),

            // Water status with animation
            AnimatedOpacity(
              opacity: _isWatered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.water_drop, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Plant is being watered! 💧',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _waterPlant,
                    icon: const Icon(Icons.water_drop),
                    label: const Text('Water Plant'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedLikeButton(
                  initialLiked: false,
                  onChanged: (liked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          liked ? 'Added to favorites! ❤️' : 'Removed from favorites',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Plant care tips with staggered animation
            const Text(
              'Care Tips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._buildCareTips(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCareTips() {
    final tips = [
      {'icon': Icons.wb_sunny, 'text': 'Bright, indirect sunlight'},
      {'icon': Icons.water_drop, 'text': 'Water when top soil is dry'},
      {'icon': Icons.thermostat, 'text': 'Temperature: 18-24°C'},
      {'icon': Icons.air, 'text': 'Good air circulation'},
    ];

    return tips.asMap().entries.map((entry) {
      final index = entry.key;
      final tip = entry.value;

      return TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 300 + (index * 100)),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  tip['icon'] as IconData,
                  color: Colors.green[700],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tip['text'] as String,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

/// Example: Add plant dialog with animations
class AddPlantDialog extends StatefulWidget {
  const AddPlantDialog({super.key});

  @override
  State<AddPlantDialog> createState() => _AddPlantDialogState();
}

class _AddPlantDialogState extends State<AddPlantDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Animate out
      _controller.reverse().then((_) {
        Navigator.pop(context);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_nameController.text} added successfully! 🌱'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Add New Plant',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Plant Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.local_florist),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a plant name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _controller.reverse().then((_) {
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Example: Loading animation
class LoadingPlantAnimation extends StatefulWidget {
  const LoadingPlantAnimation({super.key});

  @override
  State<LoadingPlantAnimation> createState() => _LoadingPlantAnimationState();
}

class _LoadingPlantAnimationState extends State<LoadingPlantAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (0.2 * (0.5 - (_controller.value - 0.5).abs())),
                child: Transform.rotate(
                  angle: _controller.value * 2 * 3.14159,
                  child: const Icon(
                    Icons.local_florist,
                    size: 80,
                    color: Colors.green,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Loading your plants...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
