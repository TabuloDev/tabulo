// test/infrastructure/repositories/http_training_repository_test.dart

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tabulo/features/training/infrastructure/repositories/http_training_repository.dart';
import '../../helpers/mock_dio.mocks.dart'; // Mock généré automatiquement

void main() {
  group('HttpTrainingRepository', () {
    late MockDio mockDio;
    late HttpTrainingRepository repository;

    setUp(() {
      mockDio = MockDio();
      repository = HttpTrainingRepository(dio: mockDio);
    });

    test('findAll renvoie une liste de Training depuis le backend', () async {
      // Arrange
      const String userId = 'user123';
      final responseData = [
        {
          "_id": "1",
          "userId": userId,
          "selectedTables": [2, 3],
          "questions": [],
          "currentIndex": 0,
          "currentAnswer": "",
          "finishedAt": "2025-07-31T10:00:00.000Z",
          "score": 9.5,
          "operations": [],
        },
      ];

      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: responseData,
          statusCode: 200,
        ),
      );

      // Act
      final trainings = await repository.findAll(userId: userId);

      // Assert
      expect(trainings.length, 1);
      expect(trainings.first.id, '1');
      expect(trainings.first.score, 9.5);
      expect(trainings.first.selectedTables, [2, 3]);
    });
  });
}
