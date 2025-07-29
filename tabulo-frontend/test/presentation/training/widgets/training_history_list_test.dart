import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/presentation/widgets/training_history_list.dart';

void main() {
  group('TrainingHistoryList', () {
    testWidgets('affiche les scores et dates des entraînements', (
      WidgetTester tester,
    ) async {
      final trainings = [
        Training(
          id: 't1',
          questions: [],
          operations: [],
          selectedTables: [2],
          currentIndex: 0,
          currentAnswer: '',
          score: 8.5,
          finishedAt: DateTime(2025, 7, 28, 14, 30),
        ),
        Training(
          id: 't2',
          questions: [],
          operations: [],
          selectedTables: [3],
          currentIndex: 0,
          currentAnswer: '',
          score: 10.0,
          finishedAt: DateTime(2025, 7, 29, 9, 0),
        ),
      ];

      final tapped = <Training>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TrainingHistoryList(
              trainings: trainings,
              onTap: (training) => tapped.add(training),
            ),
          ),
        ),
      );

      // Vérifie que les scores sont affichés
      expect(find.textContaining('8.5'), findsOneWidget);
      expect(find.textContaining('10.0'), findsOneWidget);

      // Vérifie que les dates sont bien formatées avec l'heure
      expect(find.textContaining('28/07/2025 – 14:30'), findsOneWidget);
      expect(find.textContaining('29/07/2025 – 09:00'), findsOneWidget);

      // Touche un entraînement et vérifie le rappel
      await tester.tap(find.textContaining('8.5'));
      await tester.pump();

      expect(tapped.length, 1);
      expect(tapped.first.id, 't1');
    });
  });
}
