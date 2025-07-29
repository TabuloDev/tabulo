// test/presentation/training/screens/table_selection_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/features/training/presentation/screens/table_selection_screen.dart';
import 'package:tabulo/features/training/domain/entities/question.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';
import 'package:tabulo/features/training/domain/usecases/start_training_usecase.dart';
import 'package:tabulo/features/training/domain/usecases/submit_answer_usecase.dart';
import 'package:tabulo/features/training/domain/usecases/finish_training_usecase.dart';
import 'package:tabulo/features/training/application/usecases/send_training_usecase.dart';
import 'package:tabulo/features/training/presentation/providers/training_controller_provider.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.mocks.dart';
import 'package:dio/dio.dart';

class FakeTrainingRepository implements TrainingRepository {
  final Map<String, Training> _storage = {};
  int _counter = 0;

  @override
  Future<Training> save(Training training) async {
    final id = training.id.isEmpty ? 't${_counter++}' : training.id;
    final saved = training.copyWith(id: id);
    _storage[id] = saved;
    return saved;
  }

  @override
  Future<Training?> findById(String id) async => _storage[id];

  @override
  Future<void> deleteAll() async => _storage.clear();

  @override
  Future<List<Training>> findAll({required String userId}) async =>
      _storage.values.toList();
}

void main() {
  testWidgets('Affiche les boutons 1 à 10', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: TableSelectionScreen())),
    );

    for (int i = 1; i <= 10; i++) {
      expect(find.text(i.toString()), findsOneWidget);
    }
  });

  testWidgets('Sélectionne et désélectionne un bouton de table', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: TableSelectionScreen())),
    );

    final table3 = find.text('3');
    expect(table3, findsOneWidget);

    await tester.tap(table3);
    await tester.pump();

    await tester.tap(table3);
    await tester.pump();
  });

  testWidgets(
    'Bouton "Commencer" activé seulement si une table est sélectionnée',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: TableSelectionScreen())),
      );

      final startButton = find.widgetWithText(ElevatedButton, 'Commencer');
      expect(startButton, findsOneWidget);

      final ElevatedButton buttonWidget = tester.widget(startButton);
      expect(buttonWidget.onPressed, isNull);

      await tester.tap(find.text('5'));
      await tester.pump();

      final ElevatedButton updatedButton = tester.widget(startButton);
      expect(updatedButton.onPressed, isNotNull);
    },
  );

  testWidgets('Navigue vers TrainingScreen avec les tables sélectionnées', (
    tester,
  ) async {
    final fakeTraining = Training(
      id: 't1',
      questions: [Question(2, 3)],
      operations: [],
      selectedTables: [2, 3],
      currentIndex: 0,
      currentAnswer: '',
      score: null,
      finishedAt: null,
    );

    final mockDio = MockDio();
    when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/trainings'),
        statusCode: 201,
      ),
    );

    final fakeRepo = FakeTrainingRepository();
    await fakeRepo.save(fakeTraining);

    final controller = TrainingController(
      repository: fakeRepo,
      startTrainingUseCase: StartTrainingUseCase(fakeRepo),
      submitAnswerUseCase: SubmitAnswerUseCase(fakeRepo),
      finishTrainingUseCase: FinishTrainingUseCase(fakeRepo),
      sendTrainingUseCase: SendTrainingUseCase(mockDio),
    )..state = fakeTraining;

    final container = ProviderContainer(
      overrides: [trainingControllerProvider.overrideWith((ref) => controller)],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: TableSelectionScreen()),
      ),
    );

    await tester.tap(find.text('2'));
    await tester.tap(find.text('3'));
    await tester.pump();

    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(find.text('Tables sélectionnées : 2, 3'), findsOneWidget);
  });
}
