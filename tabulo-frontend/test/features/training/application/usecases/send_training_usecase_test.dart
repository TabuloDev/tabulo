import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tabulo/features/training/application/usecases/send_training_usecase.dart';
import 'package:tabulo/features/training/domain/entities/operation.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';

import '../../../../mocks.mocks.dart'; // <- assure-toi d’avoir bien généré ce fichier avec build_runner

void main() {
  group('SendTrainingUseCase', () {
    late MockDio mockDio;
    late SendTrainingUseCase useCase;

    setUp(() {
      mockDio = MockDio();
      useCase = SendTrainingUseCase(mockDio);
    });

    test(
      'should send training to backend via POST and return true if success',
      () async {
        // Arrange
        final training = Training(
          id: 'abc123',
          questions: [],
          operations: [
            Operation(
              expression: '5 × 6',
              userAnswer: '30',
              isCorrect: true,
              correctAnswer: 30,
            ),
          ],
          selectedTables: [5, 6],
          currentAnswer: '',
          currentIndex: 0,
          score: 9.5,
          finishedAt: DateTime.parse("2025-07-29T12:00:00Z"),
        );

        when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
          (_) async => Response(
            data: {},
            statusCode: 201,
            requestOptions: RequestOptions(path: '/api/trainings'),
          ),
        );

        // Act
        final result = await useCase(training);

        // Assert
        expect(result, isTrue);
        verify(mockDio.post(any, data: anyNamed('data'))).called(1);
      },
    );

    test('should return false if backend returns error', () async {
      // Arrange
      final training = Training(
        id: 'xyz789',
        questions: [],
        operations: [],
        selectedTables: [3],
        currentAnswer: '',
        currentIndex: 0,
        score: 5.0,
        finishedAt: DateTime.now(),
      );

      when(mockDio.post(any, data: anyNamed('data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/trainings'),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(path: '/api/trainings'),
          ),
        ),
      );

      // Act
      final result = await useCase(training);

      // Assert
      expect(result, isFalse);
    });
  });
}
