// test/presentation/child/screens/training_history_navigation_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:tabulo/features/child/presentation/screens/training_detail_screen.dart';
import 'package:tabulo/features/child/presentation/screens/training_history_screen.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/presentation/providers/training_history_controller_provider.dart';

void main() {
  testWidgets(
    'navigue vers TrainingDetailScreen quand on tape sur un entraînement',
    (WidgetTester tester) async {
      await initializeDateFormatting('fr_FR');

      final trainings = [
        Training(
          id: '1',
          selectedTables: [2],
          questions: [],
          currentIndex: 0,
          currentAnswer: '',
          finishedAt: DateTime(2025, 7, 30, 14, 00),
          score: 7.0,
          operations: [],
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trainingHistoryControllerProvider.overrideWithProvider(
              (userId) =>
                  FutureProvider<List<Training>>((ref) async => trainings),
            ),
          ],
          child: MaterialApp(
            home: const TrainingHistoryScreen(userId: 'user123'),
            routes: {
              '/training-detail': (context) => const TrainingDetailScreen(),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Score : 7.0 / 10'));
      await tester.pumpAndSettle();

      expect(find.byType(TrainingDetailScreen), findsOneWidget);
    },
  );
}
