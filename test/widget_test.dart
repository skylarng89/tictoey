import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tictoey/main.dart';

void main() {
  testWidgets('TicToey app loads and displays basic UI', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TicToeyApp());

    // Wait for animations to complete
    await tester.pumpAndSettle();

    // Verify title is displayed
    expect(find.text('TicToey'), findsOneWidget);
    
    // Verify score displays are present
    expect(find.text('Player X'), findsOneWidget);
    expect(find.text('Player O'), findsOneWidget);
    expect(find.text('Draws'), findsOneWidget);
    
    // Verify reset button is present
    expect(find.text('New Game'), findsOneWidget);

    // Verify the game board is present (should have GestureDetector widgets)
    expect(find.byType(GestureDetector), findsWidgets);
  });
}
