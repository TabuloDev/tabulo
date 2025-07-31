// test/presentation/child/screens/training_detail_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tabulo/features/child/presentation/screens/training_detail_screen.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/entities/operation.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR', null);
  });

  testWidgets('TrainingDetailScreen affiche les opérations correctement', (WidgetTester tester) async {
    final training = Training(
      id: 't1',
      selectedTables: [4],
      questions: [],
      currentIndex: 0,
      currentAnswer: '',
      finishedAt: DateTime(2025, 7, 31, 9, 30),
      score: 8.5,
      operations: [
        Operation(expression: '6 × 4', userAnswer: '25', isCorrect: false, correctAnswer: 30),
        Operation(expression: '7 × 3', userAnswer: '21', isCorrect: true),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr', 'FR'),
        supportedLocales: const [Locale('fr', 'FR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: TrainingDetailScreen(training: training),
      ),
    );

    expect(find.text('Détail de l’entraînement'), findsOneWidget); // ← Apostrophe typographique
    expect(find.text('6 × 4 = 25 ❌ (corrigé : 30)'), findsOneWidget);
    expect(find.text('7 × 3 = 21 ✔️'), findsOneWidget);
  });
}
