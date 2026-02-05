import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:flutter_application_1/widgets/info_card.dart';
import 'package:flutter_application_1/widgets/like_button.dart';
import 'package:flutter_application_1/widgets/plant_care_card.dart';

void main() {
  group('Custom Widgets Tests', () {
    testWidgets('CustomButton displays label and responds to tap', (WidgetTester tester) async {
      bool buttonPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              label: 'Test Button',
              onPressed: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      // Verify button text is displayed
      expect(find.text('Test Button'), findsOneWidget);
      
      // Tap the button
      await tester.tap(find.byType(CustomButton));
      await tester.pump();
      
      // Verify callback was called
      expect(buttonPressed, true);
    });

    testWidgets('CustomButton displays icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              label: 'Test Button',
              icon: Icons.star,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify icon is displayed
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('InfoCard displays title, subtitle, and icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoCard(
              title: 'Test Title',
              subtitle: 'Test Subtitle',
              icon: Icons.info,
            ),
          ),
        ),
      );

      // Verify all elements are displayed
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('InfoCard responds to tap when onTap is provided', (WidgetTester tester) async {
      bool cardTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoCard(
              title: 'Test Title',
              subtitle: 'Test Subtitle',
              icon: Icons.info,
              onTap: () {
                cardTapped = true;
              },
            ),
          ),
        ),
      );

      // Tap the card
      await tester.tap(find.byType(InfoCard));
      await tester.pump();
      
      // Verify callback was called
      expect(cardTapped, true);
    });

    testWidgets('LikeButton toggles state when tapped', (WidgetTester tester) async {
      bool? likeState;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LikeButton(
              onLikeChanged: (isLiked) {
                likeState = isLiked;
              },
            ),
          ),
        ),
      );

      // Initially should show unliked state
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      
      // Tap to like
      await tester.tap(find.byType(LikeButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300)); // Wait for animation
      
      // Should now show liked state
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(likeState, true);
      
      // Tap again to unlike
      await tester.tap(find.byType(LikeButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300)); // Wait for animation
      
      // Should show unliked state again
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(likeState, false);
    });

    testWidgets('PlantCareCard displays plant information', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlantCareCard(
              plantName: 'Test Plant',
              careInstructions: 'Test care instructions',
              imageUrl: '',
            ),
          ),
        ),
      );

      // Verify plant information is displayed
      expect(find.text('Test Plant'), findsOneWidget);
      expect(find.text('Test care instructions'), findsOneWidget);
      expect(find.byIcon(Icons.local_florist), findsOneWidget);
    });

    testWidgets('PlantCareCard responds to tap when onTap is provided', (WidgetTester tester) async {
      bool cardTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlantCareCard(
              plantName: 'Test Plant',
              careInstructions: 'Test care instructions',
              imageUrl: '',
              onTap: () {
                cardTapped = true;
              },
            ),
          ),
        ),
      );

      // Tap the card
      await tester.tap(find.byType(PlantCareCard));
      await tester.pump();
      
      // Verify callback was called
      expect(cardTapped, true);
    });
  });
}