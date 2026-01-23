# Responsive Mobile UI – PlantCarePulse

A fully responsive Flutter application that demonstrates adaptive UI design for the PlantCarePulse plant care management screen. This screen automatically adjusts its layout based on device type (phone or tablet) and orientation (portrait or landscape), ensuring a seamless user experience across all screen sizes. The implementation uses Flutter's built-in responsive tools including MediaQuery and LayoutBuilder to create a professional, overflow-free interface.

---

## Features

- **Phone vs Tablet layout switching** – Automatically detects screen width and switches between single-column (phone) and multi-column grid (tablet) layouts
- **Portrait vs Landscape adaptive layout** – Reorganizes content into side-by-side panels in landscape mode for optimal space utilization
- **Grid/List switching** – Displays plant cards in a ListView for phones and GridView for tablets
- **Flexible UI (no overflow)** – Uses Flexible, Expanded, Wrap, and FittedBox widgets to prevent RenderFlex overflow errors
- **Adaptive sizing** – Padding, font sizes, and spacing scale proportionally based on screen dimensions
- **Debug overlay** – Optional responsive debug panel showing real-time screen metrics

---

## Responsiveness Implementation

### A) MediaQuery Usage

MediaQuery is used to obtain screen dimensions and determine device type and orientation:

```dart
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

  // ...
}
```

### B) LayoutBuilder Usage

LayoutBuilder provides parent constraints to make layout decisions based on available space:

```dart
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
          // Debug overlay...
        ],
      );
    },
  ),
),
```

### C) Layout Selection Logic

Different layouts are selected based on device type and orientation:

```dart
Widget _buildResponsiveBody({...}) {
  if (isTablet && isLandscape) {
    return _buildTabletLandscape(...);
  } else if (isTablet && !isLandscape) {
    return _buildTabletPortrait(...);
  } else if (!isTablet && isLandscape) {
    return _buildPhoneLandscape(...);
  } else {
    return _buildPhonePortrait(...);
  }
}
```

---

## Screenshots

### Phone Portrait
![Phone Portrait](assets/screenshots/phone_portrait.png)

### Phone Landscape
![Phone Landscape](assets/screenshots/phone_landscape.png)

### Tablet Portrait
![Tablet Portrait](assets/screenshots/tablet_portrait.png)

### Tablet Landscape
![Tablet Landscape](assets/screenshots/tablet_landscape.png)

---

## Reflection

Building a responsive UI in Flutter presented several challenges that deepened my understanding of adaptive design principles. One of the primary difficulties was preventing RenderFlex overflow errors, especially when transitioning between portrait and landscape orientations. Text and buttons that fit perfectly in portrait mode would often overflow in landscape, requiring careful use of Flexible, Expanded, and Wrap widgets.

Adapting the plant card layout between ListView (for phones) and GridView (for tablets) required thoughtful consideration of aspect ratios and card content constraints. The LayoutBuilder widget proved invaluable for making decisions based on actual available space rather than just screen size, which is crucial when the app might run in split-screen mode.

Responsive design significantly improves user experience by ensuring consistency across devices. Users on tablets benefit from the additional screen real estate with multi-column layouts, while phone users get a focused single-column experience. The landscape orientation provides a split-panel view that makes efficient use of horizontal space.

Through this assignment, I learned how MediaQuery and LayoutBuilder complement each other—MediaQuery for global screen properties and LayoutBuilder for local constraint-based decisions. The combination of Flexible, FittedBox, and AspectRatio widgets creates robust layouts that gracefully adapt to any screen configuration without visual breakage.

---

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run -d chrome` for web or `flutter run` for mobile
4. Navigate to the Responsive Home screen using the "Open Responsive UI" button
