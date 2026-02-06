import 'package:flutter/material.dart';

/// Responsive Design Demo using MediaQuery and LayoutBuilder
/// 
/// This screen demonstrates:
/// - MediaQuery for accessing device dimensions
/// - LayoutBuilder for conditional layouts based on constraints
/// - Adaptive UI that switches between mobile and tablet layouts
/// - Proportional sizing for different screen sizes
class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    // 📱 MediaQuery: Get device screen dimensions
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Responsive Design Demo"),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // � Device Info Card - Using MediaQuery
              _buildDeviceInfoCard(screenWidth, screenHeight, orientation),
              
              const SizedBox(height: 20),
              
              // 🎨 Responsive Container - Using MediaQuery for proportional sizing
              _buildResponsiveContainer(context, screenWidth, screenHeight),
              
              const SizedBox(height: 20),
              
              // 🔄 LayoutBuilder Demo - Conditional layouts
              _buildLayoutBuilderDemo(),
              
              const SizedBox(height: 20),
              
              // 🌟 Combined Demo - MediaQuery + LayoutBuilder
              _buildCombinedDemo(context),
              
              const SizedBox(height: 20),
              
              // 📱 Plant Cards Grid - Responsive grid layout
              _buildPlantCardsGrid(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  /// Device Information Card using MediaQuery
  Widget _buildDeviceInfoCard(double width, double height, Orientation orientation) {
    return Card(
      elevation: 4,
      color: Colors.teal[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📱 MediaQuery Device Info',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Screen Width: ${width.toStringAsFixed(1)}px'),
            Text('Screen Height: ${height.toStringAsFixed(1)}px'),
            Text('Orientation: ${orientation.name}'),
            Text('Layout Type: ${width < 600 ? "Mobile" : "Tablet"}'),
          ],
        ),
      ),
    );
  }

  /// Responsive Container using MediaQuery for proportional sizing
  Widget _buildResponsiveContainer(BuildContext context, double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎨 Responsive Container (MediaQuery)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          width: screenWidth * 0.8, // 80% of screen width
          height: screenHeight * 0.1, // 10% of screen height
          decoration: BoxDecoration(
            color: Colors.tealAccent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Width: ${(screenWidth * 0.8).toStringAsFixed(0)}px\nHeight: ${(screenHeight * 0.1).toStringAsFixed(0)}px',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  /// LayoutBuilder Demo - Shows different layouts based on constraints
  Widget _buildLayoutBuilderDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🔄 LayoutBuilder Demo',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            // Mobile layout (< 600px)
            if (constraints.maxWidth < 600) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.phone_android, size: 60, color: Colors.blue),
                    const SizedBox(height: 12),
                    const Text(
                      'Mobile Layout',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Width: ${constraints.maxWidth.toStringAsFixed(0)}px',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vertical (Column) layout for narrow screens',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              );
            } 
            // Tablet layout (>= 600px)
            else {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.tablet, size: 80, color: Colors.orange),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tablet Layout',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Width: ${constraints.maxWidth.toStringAsFixed(0)}px',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Horizontal (Row) layout for wide screens',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

  /// Combined Demo - MediaQuery + LayoutBuilder working together
  Widget _buildCombinedDemo(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🌟 Combined Demo (MediaQuery + LayoutBuilder)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile: Vertical stack
              return Column(
                children: [
                  _buildDemoCard(
                    'Plant Status',
                    Icons.local_florist,
                    Colors.green,
                    screenWidth * 0.9,
                    120,
                  ),
                  const SizedBox(height: 12),
                  _buildDemoCard(
                    'Water Schedule',
                    Icons.water_drop,
                    Colors.blue,
                    screenWidth * 0.9,
                    120,
                  ),
                ],
              );
            } else {
              // Tablet: Horizontal layout
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDemoCard(
                    'Plant Status',
                    Icons.local_florist,
                    Colors.green,
                    250,
                    150,
                  ),
                  _buildDemoCard(
                    'Water Schedule',
                    Icons.water_drop,
                    Colors.blue,
                    250,
                    150,
                  ),
                  _buildDemoCard(
                    'Care Tips',
                    Icons.lightbulb,
                    Colors.amber,
                    250,
                    150,
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  /// Helper method to build demo cards
  Widget _buildDemoCard(String title, IconData icon, Color color, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Responsive Plant Cards Grid
  Widget _buildPlantCardsGrid(double screenWidth) {
    // Calculate number of columns based on screen width
    int crossAxisCount = screenWidth < 600 ? 2 : screenWidth < 900 ? 3 : 4;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🌱 Responsive Plant Grid',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return _buildPlantCard(index);
          },
        ),
      ],
    );
  }

  /// Individual Plant Card
  Widget _buildPlantCard(int index) {
    final plants = [
      {'name': 'Monstera', 'icon': Icons.eco, 'color': Colors.green},
      {'name': 'Succulent', 'icon': Icons.spa, 'color': Colors.teal},
      {'name': 'Fern', 'icon': Icons.nature, 'color': Colors.lightGreen},
      {'name': 'Cactus', 'icon': Icons.filter_vintage, 'color': Colors.lime},
      {'name': 'Orchid', 'icon': Icons.local_florist, 'color': Colors.purple},
      {'name': 'Bamboo', 'icon': Icons.grass, 'color': Colors.green[700]},
    ];
    
    final plant = plants[index];
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              plant['icon'] as IconData,
              size: 50,
              color: plant['color'] as Color,
            ),
            const SizedBox(height: 8),
            Text(
              plant['name'] as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Healthy',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
