import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/child/presentation/screens/training_history_screen.dart';
import 'package:tabulo/features/training/presentation/providers/training_history_controller_provider.dart';

void main() {
  group('TrainingHistoryScreen', () {
    testWidgets('affiche la liste des entraînements', (
      WidgetTester tester,
    ) async {
      final fakeTrainings = [
        Training(
          id: '1',
          selectedTables: [3],
          questions: [],
          currentIndex: 0,
          currentAnswer: '',
          finishedAt: DateTime(2025, 7, 30, 10, 30),
          score: 8.5,
          operations: [],
        ),
        Training(
          id: '2',
          selectedTables: [6],
          questions: [],
          currentIndex: 0,
          currentAnswer: '',
          finishedAt: DateTime(2025, 7, 29, 9, 15),
          score: 9.0,
          operations: [],
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trainingHistoryControllerProvider.overrideWithProvider(
              (userId) =>
                  FutureProvider<List<Training>>((ref) async => fakeTrainings),
            ),
          ],
          child: const MaterialApp(
            home: TrainingHistoryScreen(userId: 'user123'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Score : 8.5 / 10'), findsOneWidget);
      expect(find.text('Score : 9.0 / 10'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsNWidgets(2));
    });

    testWidgets('affiche un message quand la liste est vide', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trainingHistoryControllerProvider.overrideWithProvider(
              (userId) => FutureProvider<List<Training>>((ref) async => []),
            ),
          ],
          child: const MaterialApp(
            home: TrainingHistoryScreen(userId: 'user123'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Aucun entraînement trouvé.'), findsOneWidget);
    });

    testWidgets('affiche un CircularProgressIndicator pendant le chargement', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trainingHistoryControllerProvider.overrideWithProvider(
              (userId) => FutureProvider<List<Training>>((ref) async {
                return Future<List<Training>>.delayed(
                  const Duration(seconds: 999),
                );
              }),
            ),
          ],
          child: const MaterialApp(
            home: TrainingHistoryScreen(userId: 'user123'),
          ),
        ),
      );

      // Vérifie l'état loading immédiatement
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('affiche une erreur si le chargement échoue', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trainingHistoryControllerProvider.overrideWithProvider(
              (userId) => FutureProvider<List<Training>>(
                (ref) async => throw Exception('Erreur réseau'),
              ),
            ),
          ],
          child: const MaterialApp(
            home: TrainingHistoryScreen(userId: 'user123'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.textContaining('Erreur'), findsOneWidget);
    });
  });
}
