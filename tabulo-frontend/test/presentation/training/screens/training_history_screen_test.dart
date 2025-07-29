import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/features/training/presentation/screens/training_history_screen.dart';

void main() {
  testWidgets('TrainingHistoryScreen displays a list of trainings', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TrainingHistoryScreen()));

    // Vérifie qu’au moins un ListTile est présent
    expect(find.byType(ListTile), findsWidgets);
  });
}
