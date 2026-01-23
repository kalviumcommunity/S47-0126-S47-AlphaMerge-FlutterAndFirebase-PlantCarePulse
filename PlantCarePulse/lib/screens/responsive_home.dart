import 'dart:math' as math;
import 'package:flutter/material.dart';

const bool kShowResponsiveDebug = true;

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  double _clampPadding(double value) {
    return math.max(12, math.min(24, value));
  }

  String _getLayoutModeName(bool isTablet, bool isLandscape) {
    if (isTablet && isLandscape) {
      return 'Tablet Landscape';
    } else if (isTablet && !isLandscape) {
      return 'Tablet Portrait';
    } else if (!isTablet && isLandscape) {
      return 'Phone Landscape';
    } else {
      return 'Phone Portrait';
    }
  }

  Widget _buildDebugOverlay({
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
    required bool isLandscape,
  }) {
    if (!kShowResponsiveDebug) {
      return const SizedBox.shrink();
    }

    final layoutMode = _getLayoutModeName(isTablet, isLandscape);

    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'DEBUG',
              style: TextStyle(
                color: Colors.amber.shade300,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Width: ${screenWidth.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            Text(
              'Height: ${screenHeight.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            Text(
              'isTablet: $isTablet',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            Text(
              'isLandscape: $isLandscape',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            const Divider(color: Colors.white38, height: 8),
            Text(
              layoutMode,
              style: TextStyle(
                color: Colors.greenAccent.shade200,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final bool isTablet = screenWidth > 600;
    final bool isLandscape = screenWidth > screenHeight;

    final double basePadding = _clampPadding(screenWidth * 0.04);

    final double titleSize = isTablet ? 22 : 18;
    final double bodySize = isTablet ? 16 : 14;

    return Scaffold(
      appBar: _buildHeader(context, isTablet),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isTabletLayout = constraints.maxWidth > 600;

            return Stack(
              children: [
                _buildResponsiveBody(
                  context: context,
                  constraints: constraints,
                  isTablet: isTabletLayout,
                  isLandscape: isLandscape,
                  basePadding: basePadding,
                  titleSize: titleSize,
                  bodySize: bodySize,
                ),
                _buildDebugOverlay(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  isTablet: isTablet,
                  isLandscape: isLandscape,
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildFooterActions(
        context: context,
        screenWidth: screenWidth,
        isTablet: isTablet,
        basePadding: basePadding,
      ),
    );
  }

  PreferredSizeWidget _buildHeader(BuildContext context, bool isTablet) {
    return AppBar(
      title: Text(
        'Responsive Home',
        style: TextStyle(fontSize: isTablet ? 22 : 18),
      ),
      centerTitle: true,
      backgroundColor: Colors.green.shade700,
      foregroundColor: Colors.white,
      elevation: 2,
      toolbarHeight: isTablet ? 64 : 56,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, size: isTablet ? 28 : 24),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.person_outline, size: isTablet ? 28 : 24),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildResponsiveBody({
    required BuildContext context,
    required BoxConstraints constraints,
    required bool isTablet,
    required bool isLandscape,
    required double basePadding,
    required double titleSize,
    required double bodySize,
  }) {
    if (isTablet && isLandscape) {
      return _buildTabletLandscape(
        context: context,
        constraints: constraints,
        basePadding: basePadding,
        titleSize: titleSize,
        bodySize: bodySize,
      );
    } else if (isTablet && !isLandscape) {
      return _buildTabletPortrait(
        context: context,
        constraints: constraints,
        basePadding: basePadding,
        titleSize: titleSize,
        bodySize: bodySize,
      );
    } else if (!isTablet && isLandscape) {
      return _buildPhoneLandscape(
        context: context,
        constraints: constraints,
        basePadding: basePadding,
        titleSize: titleSize,
        bodySize: bodySize,
      );
    } else {
      return _buildPhonePortrait(
        context: context,
        constraints: constraints,
        basePadding: basePadding,
        titleSize: titleSize,
        bodySize: bodySize,
      );
    }
  }

  Widget _buildPhonePortrait({
    required BuildContext context,
    required BoxConstraints constraints,
    required double basePadding,
    required double titleSize,
    required double bodySize,
  }) {
    final plants = _getPlantData();

    return SingleChildScrollView(
      padding: EdgeInsets.all(basePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBanner(
            context: context,
            maxWidth: constraints.maxWidth,
            titleSize: titleSize,
            bodySize: bodySize,
          ),
          SizedBox(height: basePadding),
          _buildSectionTitle('Your Plants', titleSize),
          SizedBox(height: basePadding / 2),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: plants.length,
            separatorBuilder: (context, index) => SizedBox(height: basePadding * 0.75),
            itemBuilder: (context, index) => _buildPlantCard(
              plant: plants[index],
              bodySize: bodySize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneLandscape({
    required BuildContext context,
    required BoxConstraints constraints,
    required double basePadding,
    required double titleSize,
    required double bodySize,
  }) {
    final plants = _getPlantData();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(basePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBanner(
                  context: context,
                  maxWidth: constraints.maxWidth * 0.4,
                  titleSize: titleSize,
                  bodySize: bodySize,
                ),
                SizedBox(height: basePadding),
                _buildQuickStatsPanel(bodySize: bodySize),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(basePadding, basePadding, basePadding, 0),
                child: _buildSectionTitle('Your Plants', titleSize),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(basePadding),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: plants.length,
                    itemBuilder: (context, index) => _buildPlantCard(
                      plant: plants[index],
                      bodySize: bodySize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletPortrait({
    required BuildContext context,
    required BoxConstraints constraints,
    required double basePadding,
    required double titleSize,
    required double bodySize,
  }) {
    final plants = _getPlantData();
    final cardSpacing = basePadding;

    return SingleChildScrollView(
      padding: EdgeInsets.all(basePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBanner(
            context: context,
            maxWidth: constraints.maxWidth,
            titleSize: titleSize,
            bodySize: bodySize,
          ),
          SizedBox(height: basePadding * 1.5),
          _buildSectionTitle('Your Plants', titleSize),
          SizedBox(height: basePadding),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: cardSpacing,
              mainAxisSpacing: cardSpacing,
            ),
            itemCount: plants.length,
            itemBuilder: (context, index) => _buildPlantCard(
              plant: plants[index],
              bodySize: bodySize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLandscape({
    required BuildContext context,
    required BoxConstraints constraints,
    required double basePadding,
    required double titleSize,
    required double bodySize,
  }) {
    final plants = _getPlantData();
    final int crossAxisCount = constraints.maxWidth > 1000 ? 3 : 2;
    final cardSpacing = basePadding;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.green.shade50,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(basePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBanner(
                    context: context,
                    maxWidth: constraints.maxWidth * 0.35,
                    titleSize: titleSize,
                    bodySize: bodySize,
                  ),
                  SizedBox(height: basePadding * 1.5),
                  _buildQuickStatsPanel(bodySize: bodySize),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(basePadding, basePadding, basePadding, 0),
                child: _buildSectionTitle('Your Plants', titleSize),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(basePadding),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: cardSpacing,
                      mainAxisSpacing: cardSpacing,
                    ),
                    itemCount: plants.length,
                    itemBuilder: (context, index) => _buildPlantCard(
                      plant: plants[index],
                      bodySize: bodySize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBanner({
    required BuildContext context,
    required double maxWidth,
    required double titleSize,
    required double bodySize,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.green.shade50,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 80, maxHeight: 80),
                decoration: BoxDecoration(
                  color: Colors.green.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.eco,
                      size: 48,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Welcome to Plant Care Pulse',
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      'Track your plants health, watering schedules, and get personalized care tips.',
                      style: TextStyle(
                        fontSize: bodySize,
                        color: Colors.green.shade700,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildSectionTitle(String title, double titleSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: titleSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildPlantCard({
    required Map<String, dynamic> plant,
    required double bodySize,
  }) {
    final isHealthy = plant['status'] == 'Healthy';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 180;
            final iconSize = isCompact ? 36.0 : 48.0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: iconSize,
                            maxHeight: iconSize,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                plant['icon'] as IconData,
                                color: Colors.green.shade700,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              plant['name'] as String,
                              style: TextStyle(
                                fontSize: bodySize,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            _buildStatusChip(
                              status: plant['status'] as String,
                              isHealthy: isHealthy,
                              fontSize: bodySize - 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.water_drop_outlined,
                      size: bodySize,
                      color: Colors.blue.shade400,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        plant['schedule'] as String,
                        style: TextStyle(
                          fontSize: bodySize - 1,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusChip({
    required String status,
    required bool isHealthy,
    required double fontSize,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isHealthy ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: isHealthy ? Colors.green.shade800 : Colors.orange.shade800,
        ),
      ),
    );
  }

  Widget _buildFooterActions({
    required BuildContext context,
    required double screenWidth,
    required bool isTablet,
    required double basePadding,
  }) {
    final isSmallScreen = screenWidth < 400;
    final buttonMinWidth = isTablet ? 140.0 : (isSmallScreen ? 90.0 : 110.0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: basePadding,
        vertical: basePadding * 0.75,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Wrap(
          spacing: basePadding,
          runSpacing: basePadding * 0.5,
          alignment: WrapAlignment.center,
          children: [
            _buildActionButton(
              icon: Icons.add_circle_outline,
              label: 'Add Plant',
              color: Colors.green,
              isCompact: isSmallScreen,
              minWidth: buttonMinWidth,
              onPressed: () {},
            ),
            _buildActionButton(
              icon: Icons.qr_code_scanner,
              label: 'Scan',
              color: Colors.blue,
              isCompact: isSmallScreen,
              minWidth: buttonMinWidth,
              onPressed: () {},
            ),
            _buildActionButton(
              icon: Icons.settings_outlined,
              label: 'Settings',
              color: Colors.grey.shade700,
              isCompact: isSmallScreen,
              minWidth: buttonMinWidth,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isCompact,
    required double minWidth,
    required VoidCallback onPressed,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: isCompact ? 18 : 20),
        label: Flexible(
          child: Text(
            label,
            style: TextStyle(fontSize: isCompact ? 12 : 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 12 : 20,
            vertical: isCompact ? 10 : 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsPanel({required double bodySize}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: bodySize + 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow(Icons.eco, 'Total Plants', '6', bodySize),
            const SizedBox(height: 12),
            _buildStatRow(Icons.favorite, 'Healthy', '4', bodySize),
            const SizedBox(height: 12),
            _buildStatRow(Icons.water_drop, 'Need Water', '2', bodySize),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, double bodySize) {
    return Row(
      children: [
        Icon(icon, size: bodySize + 4, color: Colors.green.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: bodySize),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bodySize + 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getPlantData() {
    return [
      {
        'name': 'Aloe Vera',
        'status': 'Healthy',
        'schedule': 'Water every 2 weeks',
        'icon': Icons.spa,
      },
      {
        'name': 'Snake Plant',
        'status': 'Healthy',
        'schedule': 'Water every 3 weeks',
        'icon': Icons.grass,
      },
      {
        'name': 'Peace Lily',
        'status': 'Needs Water',
        'schedule': 'Water weekly',
        'icon': Icons.local_florist,
      },
      {
        'name': 'Monstera',
        'status': 'Healthy',
        'schedule': 'Water every 10 days',
        'icon': Icons.yard,
      },
      {
        'name': 'Spider Plant',
        'status': 'Needs Water',
        'schedule': 'Water twice weekly',
        'icon': Icons.nature,
      },
      {
        'name': 'Pothos',
        'status': 'Healthy',
        'schedule': 'Water every 2 weeks',
        'icon': Icons.eco,
      },
    ];
  }
}
