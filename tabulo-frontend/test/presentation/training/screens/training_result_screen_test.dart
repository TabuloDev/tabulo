import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/entities/operation.dart';
import 'package:tabulo/features/training/presentation/screens/training_result_screen.dart';

void main() {
  group('TrainingResultScreen', () {
    testWidgets('affiche un message motivant pour un score élevé', (
      tester,
    ) async {
      final training = Training(
        id: '1',
        questions: [],
        operations: [
          Operation(
            expression: '6 × 4',
            userAnswer: '24',
            isCorrect: true,
            correctAnswer: 24,
          ),
        ],
        selectedTables: [2],
        currentIndex: 0,
        currentAnswer: '',
        score: 9.5,
        finishedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(home: TrainingResultScreen(training: training)),
      );

      expect(find.textContaining('9.5'), findsOneWidget);
      expect(find.textContaining('Excellent travail'), findsOneWidget);
      expect(find.textContaining('6 × 4 = 24'), findsOneWidget);
    });

    testWidgets('affiche un message motivant moyen pour un score moyen', (
      tester,
    ) async {
      final training = Training(
        id: '2',
        questions: [],
        operations: [
          Operation(
            expression: '5 × 5',
            userAnswer: '24',
            isCorrect: false,
            correctAnswer: 25,
          ),
        ],
        selectedTables: [3],
        currentIndex: 0,
        currentAnswer: '',
        score: 6.0,
        finishedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(home: TrainingResultScreen(training: training)),
      );

      expect(find.textContaining('6.0'), findsOneWidget);
      expect(find.textContaining('continue comme ça'), findsOneWidget);
      expect(find.textContaining('Correction : 5 × 5 = 25'), findsOneWidget);
    });

    testWidgets('affiche un message encourageant pour un score faible', (
      tester,
    ) async {
      final training = Training(
        id: '3',
        questions: [],
        operations: [
          Operation(
            expression: '7 × 3',
            userAnswer: '12',
            isCorrect: false,
            correctAnswer: 21,
          ),
        ],
        selectedTables: [4],
        currentIndex: 0,
        currentAnswer: '',
        score: 3.0,
        finishedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(home: TrainingResultScreen(training: training)),
      );

      expect(find.textContaining('3.0'), findsOneWidget);
      expect(find.textContaining('Tu progresses'), findsOneWidget);
      expect(find.textContaining('Correction : 7 × 3 = 21'), findsOneWidget);
    });
  });
}
