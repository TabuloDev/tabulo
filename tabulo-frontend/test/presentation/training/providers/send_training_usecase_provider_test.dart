import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';

import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/application/usecases/send_training_usecase.dart';
import 'package:tabulo/features/training/presentation/providers/send_training_usecase_provider.dart';

import 'send_training_usecase_provider_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  test(
    'sendTrainingUseCaseProvider utilise Dio et envoie le training',
    () async {
      // Arrange
      final mockDio = MockDio();
      final container = ProviderContainer(
        overrides: [
          sendTrainingUseCaseProvider.overrideWithValue(
            SendTrainingUseCase(mockDio),
          ),
        ],
      );
      addTearDown(container.dispose);

      final training = Training(
        id: '1',
        questions: [],
        operations: [],
        selectedTables: [2],
        currentIndex: 0,
        currentAnswer: '',
        score: 10,
        finishedAt: DateTime.now(),
      );

      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/trainings'),
          statusCode: 201,
        ),
      );

      // Act
      final useCase = container.read(sendTrainingUseCaseProvider);
      final result = await useCase.call(training);

      // Assert
      expect(result, isTrue);
      verify(mockDio.post('/api/trainings', data: anyNamed('data'))).called(1);
    },
  );
}
