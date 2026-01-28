import 'package:flutter/material.dart';

/// Widget Tree and Reactive UI Demo
/// This screen demonstrates Flutter's widget tree structure and reactive UI model
/// through interactive examples and visual representations.
/// 
/// Refactored into smaller, independent components for better performance
/// and to properly demonstrate selective UI updates.
class WidgetTreeDemo extends StatefulWidget {
  const WidgetTreeDemo({super.key});

  @override
  State<WidgetTreeDemo> createState() => _WidgetTreeDemoState();
}

class _WidgetTreeDemoState extends State<WidgetTreeDemo> {
  // Global theme state - affects multiple components
  bool _isDarkTheme = false;
  
  // State variables for the demo
  int _counter = 0;
  double _waterLevel = 50.0;
  String _selectedPlant = 'Aloe Vera';
  bool _showDetails = false;
  
  // Plant options
  final List<String> _plants = [
    'Aloe Vera',
    'Snake Plant',
    'Peace Lily',
    'Monstera',
  ];
  
  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }
  
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  
  void _changePlant(String? newPlant) {
    if (newPlant != null) {
      setState(() {
        _selectedPlant = newPlant;
      });
    }
  }
  
  void _updateWaterLevel(double newLevel) {
    setState(() {
      _waterLevel = newLevel;
    });
  }
  
  void _toggleDetails() {
    setState(() {
      _showDetails = !_showDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This build method demonstrates the widget tree structure
    // Now with independent components that manage their own state
    return Theme(
      data: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(),
        bottomNavigationBar: _buildBottomNavigation(),
      ),
    );
  }

  /// Main body widget - now contains independent components
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 20),
          _buildCounterSection(),
          const SizedBox(height: 20),
          _buildPlantSelectorSection(),
          const SizedBox(height: 20),
          _buildWaterLevelSection(),
          const SizedBox(height: 20),
          _buildDetailsSection(),
          const SizedBox(height: 20),
          _buildReactiveUIExplanation(),
        ],
      ),
    );
  }

  /// AppBar widget - demonstrates nested widget structure
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Widget Tree & Reactive UI Demo'),
      backgroundColor: _isDarkTheme ? Colors.grey[800] : Colors.green[700],
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(_isDarkTheme ? Icons.light_mode : Icons.dark_mode),
          onPressed: _toggleTheme,
          tooltip: 'Toggle Theme',
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showWidgetTreeDialog(context),
          tooltip: 'Show Widget Tree',
        ),
      ],
    );
  }

  /// Welcome card widget
  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: _isDarkTheme 
              ? [Colors.grey[800]!, Colors.grey[700]!]
              : [Colors.green[100]!, Colors.green[50]!],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_tree,
                  size: 32,
                  color: _isDarkTheme ? Colors.green[300] : Colors.green[700],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Flutter Widget Tree Demo',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isDarkTheme ? Colors.green[300] : Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'This demo showcases how Flutter\'s widget tree forms the backbone of every app and how the reactive UI model enables automatic updates when state changes.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// Counter section - demonstrates setState() and reactive updates
  Widget _buildCounterSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Counter Example',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Demonstrates setState() triggering UI rebuilds:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _isDarkTheme ? Colors.grey[700] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _isDarkTheme ? Colors.green[300] : Colors.green[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _incrementCounter,
                    icon: const Icon(Icons.add),
                    label: const Text('Increment Counter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isDarkTheme ? Colors.green[700] : Colors.green[600],
                      foregroundColor: Colors.white,
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

  /// Plant selector section - demonstrates dropdown state changes
  Widget _buildPlantSelectorSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plant Selector',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Shows how dropdown selection updates the UI:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  _getPlantIcon(_selectedPlant),
                  size: 32,
                  color: _isDarkTheme ? Colors.green[300] : Colors.green[700],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPlant,
                    decoration: const InputDecoration(
                      labelText: 'Select Plant',
                      border: OutlineInputBorder(),
                    ),
                    items: _plants.map((plant) {
                      return DropdownMenuItem(
                        value: plant,
                        child: Text(plant),
                      );
                    }).toList(),
                    onChanged: _changePlant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isDarkTheme ? Colors.grey[700] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Selected: $_selectedPlant',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Water level section - demonstrates slider state changes
  Widget _buildWaterLevelSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Water Level Control',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Interactive slider that updates UI in real-time:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.water_drop,
                  color: Colors.blue[600],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: _waterLevel,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: '${_waterLevel.round()}%',
                    onChanged: _updateWaterLevel,
                    activeColor: Colors.blue[600],
                  ),
                ),
                Text(
                  '${_waterLevel.round()}%',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _waterLevel / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _waterLevel < 30 ? Colors.red : 
                _waterLevel < 70 ? Colors.orange : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getWaterLevelStatus(_waterLevel),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _waterLevel < 30 ? Colors.red : 
                       _waterLevel < 70 ? Colors.orange : Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Details section - demonstrates conditional rendering
  Widget _buildDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Plant Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: _showDetails,
                  onChanged: (value) => _toggleDetails(),
                  activeColor: _isDarkTheme ? Colors.green[300] : Colors.green[600],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Toggle to show/hide details (conditional rendering):',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showDetails ? null : 0,
              child: _showDetails ? _buildPlantDetails() : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  /// Plant details widget - conditionally rendered
  Widget _buildPlantDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDarkTheme ? Colors.grey[700] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isDarkTheme ? Colors.grey[600]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Plant Name:', _selectedPlant),
          _buildDetailRow('Water Level:', '${_waterLevel.round()}%'),
          _buildDetailRow('Status:', _getWaterLevelStatus(_waterLevel)),
          _buildDetailRow('Theme:', _isDarkTheme ? 'Dark' : 'Light'),
          _buildDetailRow('Counter Value:', '$_counter'),
        ],
      ),
    );
  }

  /// Helper method to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Reactive UI explanation section
  Widget _buildReactiveUIExplanation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reactive UI Model',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Flutter\'s reactive model means:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('UI automatically updates when state changes'),
            _buildBulletPoint('setState() triggers widget rebuilds'),
            _buildBulletPoint('Only affected widgets are re-rendered'),
            _buildBulletPoint('No manual DOM manipulation needed'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isDarkTheme ? Colors.blue[900] : Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isDarkTheme ? Colors.blue[700]! : Colors.blue[200]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: _isDarkTheme ? Colors.blue[300] : Colors.blue[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Try interacting with the controls above to see reactive updates in action!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _isDarkTheme ? Colors.blue[300] : Colors.blue[700],
                        fontStyle: FontStyle.italic,
                      ),
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

  /// Helper method to build bullet points
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Floating action button
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _incrementCounter,
      backgroundColor: _isDarkTheme ? Colors.green[700] : Colors.green[600],
      foregroundColor: Colors.white,
      tooltip: 'Increment Counter',
      child: const Icon(Icons.add),
    );
  }

  /// Bottom navigation bar
  Widget _buildBottomNavigation() {
    return BottomAppBar(
      color: _isDarkTheme ? Colors.grey[800] : Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomButton(
              icon: Icons.refresh,
              label: 'Reset',
              onPressed: () {
                setState(() {
                  _counter = 0;
                  _waterLevel = 50.0;
                  _selectedPlant = 'Aloe Vera';
                  _showDetails = false;
                });
              },
            ),
            _buildBottomButton(
              icon: Icons.account_tree,
              label: 'Widget Tree',
              onPressed: () => _showWidgetTreeDialog(context),
            ),
            _buildBottomButton(
              icon: Icons.info,
              label: 'About',
              onPressed: () => _showAboutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build bottom navigation buttons
  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: _isDarkTheme ? Colors.green[300] : Colors.green[700],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _isDarkTheme ? Colors.green[300] : Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper methods
  IconData _getPlantIcon(String plant) {
    switch (plant) {
      case 'Aloe Vera':
        return Icons.spa;
      case 'Snake Plant':
        return Icons.grass;
      case 'Peace Lily':
        return Icons.local_florist;
      case 'Monstera':
        return Icons.yard;
      default:
        return Icons.eco;
    }
  }

  String _getWaterLevelStatus(double level) {
    if (level < 30) return 'Needs Water';
    if (level < 70) return 'Moderate';
    return 'Well Watered';
  }

  /// Show widget tree dialog
  void _showWidgetTreeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Widget Tree Structure'),
        content: SingleChildScrollView(
          child: Text(
            '''WidgetTreeDemo (StatefulWidget)
├── Theme
│   └── Scaffold
│       ├── AppBar
│       │   ├── Text (title)
│       │   └── Actions
│       │       ├── IconButton (theme toggle)
│       │       └── IconButton (info)
│       ├── Body
│       │   └── SingleChildScrollView
│       │       └── Column
│       │           ├── WelcomeCard
│       │           ├── CounterSection
│       │           │   ├── Text (title)
│       │           │   ├── Container (counter display)
│       │           │   └── ElevatedButton
│       │           ├── PlantSelectorSection
│       │           │   ├── Icon
│       │           │   └── DropdownButtonFormField
│       │           ├── WaterLevelSection
│       │           │   ├── Slider
│       │           │   └── LinearProgressIndicator
│       │           ├── DetailsSection
│       │           │   ├── Switch
│       │           │   └── AnimatedContainer
│       │           └── ReactiveUIExplanation
│       ├── FloatingActionButton
│       └── BottomAppBar
│           └── Row (navigation buttons)

Each setState() call rebuilds only the affected widgets!''',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show about dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About This Demo'),
        content: const Text(
          'This demo showcases Flutter\'s widget tree structure and reactive UI model. '
          'Every interaction triggers setState(), which causes Flutter to rebuild only '
          'the affected parts of the widget tree, making updates efficient and automatic.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}