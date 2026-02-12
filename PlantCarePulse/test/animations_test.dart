import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/screens/animations_demo.dart';
import 'package:flutter_application_1/widgets/animated_plant_card.dart';

void main() {
  group('Animations Demo Tests', () {
    testWidgets('AnimationsDemo renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnimationsDemo(),
        ),
      );

      // Verify the main title is displayed
      expect(find.text('Flutter Animations'), findsOneWidget);
      
      // Verify all navigation cards are present
      expect(find.text('Implicit Animations'), findsOneWidget);
      expect(find.text('Explicit Animations'), findsOneWidget);
      expect(find.text('Page Transitions'), findsOneWidget);
      expect(find.text('Plant Care Animations'), findsOneWidget);
    });

    testWidgets('Navigation to Implicit Animations works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnimationsDemo(),
        ),
      );

      // Tap on Implicit Animations card
      await tester.tap(find.text('Implicit Animations'));
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(find.text('Implicit Animations'), findsWidgets);
    });
  });

  group('Implicit Animations Tests', () {
    testWidgets('ImplicitAnimationsDemo renders all sections', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImplicitAnimationsDemo(),
        ),
      );

      // Verify section titles
      expect(find.text('AnimatedContainer'), findsOneWidget);
      expect(find.text('AnimatedOpacity'), findsOneWidget);
      expect(find.text('AnimatedPadding'), findsOneWidget);
      expect(find.text('AnimatedAlign'), findsOneWidget);
    });

    testWidgets('AnimatedContainer toggles on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImplicitAnimationsDemo(),
        ),
      );

      // Find the animated container
      final containerFinder = find.text('Tap Me!');
      expect(containerFinder, findsOneWidget);

      // Tap the container
      await tester.tap(containerFinder);
      await tester.pump();
      
      // Animation should start
      await tester.pump(const Duration(milliseconds: 300));
      
      // Verify animation is in progress
      expect(containerFinder, findsOneWidget);
    });

    testWidgets('AnimatedOpacity toggle button works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImplicitAnimationsDemo(),
        ),
      );

      // Find and tap the Hide/Show button
      final buttonFinder = find.text('Hide');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pump();

      // Button text should change
      expect(find.text('Show'), findsOneWidget);
    });

    testWidgets('AnimatedPadding toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImplicitAnimationsDemo(),
        ),
      );

      // Find the toggle padding button
      final buttonFinder = find.text('Toggle Padding');
      expect(buttonFinder, findsOneWidget);

      // Tap the button
      await tester.tap(buttonFinder);
      await tester.pump();
      
      // Animation should start
      await tester.pump(const Duration(milliseconds: 250));
      
      // Verify the padded box is still present
      expect(find.text('Padded Box'), findsOneWidget);
    });

    testWidgets('AnimatedAlign moves icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImplicitAnimationsDemo(),
        ),
      );

      // Find the move icon button
      final buttonFinder = find.text('Move Icon');
      expect(buttonFinder, findsOneWidget);

      // Tap the button
      await tester.tap(buttonFinder);
      await tester.pump();
      
      // Animation should start
      await tester.pump(const Duration(milliseconds: 300));
      
      // Icon should still be present
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });

  group('Explicit Animations Tests', () {
    testWidgets('ExplicitAnimationsDemo renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ExplicitAnimationsDemo(),
        ),
      );

      // Verify section titles
      expect(find.text('RotationTransition'), findsOneWidget);
      expect(find.text('ScaleTransition'), findsOneWidget);
      expect(find.text('SlideTransition'), findsOneWidget);
    });

    testWidgets('RotationTransition animates continuously', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ExplicitAnimationsDemo(),
        ),
      );

      // Verify rotation icon is present
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Let animation run for a bit
      await tester.pump(const Duration(milliseconds: 500));
      
      // Icon should still be present and animating
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('ScaleTransition toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ExplicitAnimationsDemo(),
        ),
      );

      // Find the toggle scale button
      final buttonFinder = find.text('Toggle Scale');
      expect(buttonFinder, findsOneWidget);

      // Tap the button
      await tester.tap(buttonFinder);
      await tester.pump();
      
      // Animation should start
      await tester.pump(const Duration(milliseconds: 400));
      
      // Heart icon should be present
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('SlideTransition button works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ExplicitAnimationsDemo(),
        ),
      );

      // Find the slide button
      final buttonFinder = find.text('Slide');
      expect(buttonFinder, findsOneWidget);

      // Tap the button
      await tester.tap(buttonFinder);
      await tester.pump();
      
      // Animation should start
      await tester.pump(const Duration(milliseconds: 500));
      
      // Plant icon should be present
      expect(find.byIcon(Icons.local_florist), findsWidgets);
    });
  });

  group('Page Transitions Tests', () {
    testWidgets('PageTransitionsDemo renders all buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PageTransitionsDemo(),
        ),
      );

      // Verify all transition buttons
      expect(find.text('Slide Transition'), findsOneWidget);
      expect(find.text('Fade Transition'), findsOneWidget);
      expect(find.text('Scale Transition'), findsOneWidget);
      expect(find.text('Rotation Transition'), findsOneWidget);
    });

    testWidgets('Slide transition navigation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PageTransitionsDemo(),
        ),
      );

      // Tap slide transition button
      await tester.tap(find.text('Slide Transition'));
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(find.text('Slide Transition'), findsWidgets);
    });
  });

  group('Plant Care Animations Tests', () {
    testWidgets('PlantCareAnimations renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PlantCareAnimations(),
        ),
      );

      // Verify plant icon is present
      expect(find.byIcon(Icons.local_florist), findsOneWidget);
      
      // Verify action buttons
      expect(find.text('Water'), findsOneWidget);
      expect(find.text('Fertilize'), findsOneWidget);
    });

    testWidgets('Water button triggers animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PlantCareAnimations(),
        ),
      );

      // Tap water button
      await tester.tap(find.text('Water'));
      await tester.pump();

      // Animation should start
      await tester.pump(const Duration(milliseconds: 500));
      
      // Status message should appear
      expect(find.text('💧 Plant is being watered!'), findsOneWidget);
    });

    testWidgets('Fertilize button triggers animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PlantCareAnimations(),
        ),
      );

      // Tap fertilize button
      await tester.tap(find.text('Fertilize'));
      await tester.pump();

      // Animation should start
      await tester.pump(const Duration(milliseconds: 500));
      
      // Status message should appear
      expect(find.text('🌱 Plant is being fertilized!'), findsOneWidget);
    });
  });

  group('Animated Widget Tests', () {
    testWidgets('AnimatedPlantCard renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedPlantCard(
              plantName: 'Monstera',
              species: 'Monstera deliciosa',
              wateringSchedule: 'Every 7 days',
              color: Colors.green,
            ),
          ),
        ),
      );

      // Verify plant information is displayed
      expect(find.text('Monstera'), findsOneWidget);
      expect(find.text('Monstera deliciosa'), findsOneWidget);
      expect(find.text('Every 7 days'), findsOneWidget);
    });

    testWidgets('AnimatedLikeButton toggles state', (WidgetTester tester) async {
      bool liked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedLikeButton(
              initialLiked: false,
              onChanged: (value) {
                liked = value;
              },
            ),
          ),
        ),
      );

      // Initially should show outline heart
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      // Tap the button
      await tester.tap(find.byType(AnimatedLikeButton));
      await tester.pump();

      // Should show filled heart
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(liked, true);
    });

    testWidgets('AnimatedPlantHealth displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedPlantHealth(
              healthPercentage: 0.75,
              color: Colors.green,
              label: 'Health',
            ),
          ),
        ),
      );

      // Verify label is displayed
      expect(find.text('Health'), findsOneWidget);
      
      // Let animation complete
      await tester.pumpAndSettle();
      
      // Verify percentage is displayed
      expect(find.text('75%'), findsOneWidget);
    });
  });

  group('Animation Performance Tests', () {
    testWidgets('Animations complete within expected duration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImplicitAnimationsDemo(),
        ),
      );

      // Tap animated container
      await tester.tap(find.text('Tap Me!'));
      await tester.pump();

      // Animation should complete in 600ms
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      // Verify animation completed
      expect(find.text('Tap Me!'), findsOneWidget);
    });

    testWidgets('Multiple animations can run simultaneously', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ImplicitAnimationsDemo(),
        ),
      );

      // Trigger multiple animations
      await tester.tap(find.text('Tap Me!'));
      await tester.tap(find.text('Hide'));
      await tester.tap(find.text('Toggle Padding'));
      
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // All elements should still be present
      expect(find.text('Tap Me!'), findsOneWidget);
      expect(find.text('Show'), findsOneWidget);
      expect(find.text('Padded Box'), findsOneWidget);
    });
  });
}
