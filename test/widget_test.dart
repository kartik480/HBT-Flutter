import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habit_tracker/main.dart';

void main() {
  testWidgets('Habit Tracker app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HabitTrackerApp());

    // Verify that the app title is displayed
    expect(find.text('Habit Tracker'), findsOneWidget);
  });
}
