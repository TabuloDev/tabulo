import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tabulo/features/training/domain/entities/question.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';
import 'package:tabulo/features/training/domain/usecases/start_training_usecase.dart';
import 'package:tabulo/features/training/domain/usecases/submit_answer_usecase.dart';
import 'package:tabulo/features/training/domain/usecases/finish_training_usecase.dart';
import 'package:tabulo/features/training/application/usecases/send_training_usecase.dart';
import 'package:tabulo/features/training/presentation/providers/training_controller_provider.dart';
import 'package:tabulo/features/training/presentation/screens/training_screen.dart';
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
  testWidgets('TrainingScreen displays question and handles answer', (
    WidgetTester tester,
  ) async {
    final repository = FakeTrainingRepository();
    final training = Training(
      id: 'training-1',
      questions: [Question(6, 4), Question(2, 2)], // ✅ Deux questions
      operations: [],
      selectedTables: [6],
      currentAnswer: '',
      currentIndex: 0,
      score: null,
      finishedAt: null,
    );
    await repository.save(training);

    final startTrainingUseCase = StartTrainingUseCase(repository);
    final submitAnswerUseCase = SubmitAnswerUseCase(repository);
    final finishTrainingUseCase = FinishTrainingUseCase(repository);

    final mockDio = MockDio();
    when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/trainings'),
        statusCode: 201,
      ),
    );

    final sendTrainingUseCase = SendTrainingUseCase(mockDio);

    final controller = TrainingController(
      repository: repository,
      startTrainingUseCase: startTrainingUseCase,
      submitAnswerUseCase: submitAnswerUseCase,
      finishTrainingUseCase: finishTrainingUseCase,
      sendTrainingUseCase: sendTrainingUseCase,
    )..state = training;

    final container = ProviderContainer(
      overrides: [trainingControllerProvider.overrideWith((ref) => controller)],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: TrainingScreen(selectedTables: [6])),
      ),
    );

    expect(find.text('6 × 4'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '24');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // ✅ On peut maintenant vérifier la présence du feedback
    expect(find.byKey(const Key('feedbackMessage')), findsOneWidget);
    expect(find.text('Bonne réponse !'), findsOneWidget);
  });
}
