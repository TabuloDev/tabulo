// test/presentation/training/providers/trainings_provider_test.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/core/dio_client.dart';
import 'package:tabulo/features/training/presentation/providers/trainings_provider.dart';

void main() {
  test('🧪 TRAININGS: parsing mockData works', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.uri.queryParameters['userId'] == 'test-user') {
              final mockData = [
                {
                  '_id': 'training-id-1',
                  'userId': 'test-user',
                  'selectedTables': [2, 3],
                  'score': 9.5,
                  'finishedAt': '2025-07-27T00:00:00.000',
                  'operations': [
                    {
                      'expression': '2 x 3',
                      'userAnswer': '6',
                      'isCorrect': true,
                      'correction': null,
                    },
                  ],
                },
              ];

              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: mockData,
                ),
              );
            }

            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 404,
                  statusMessage: 'Not Found',
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          },
        ),
      );

    final container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(dio)],
    );
    addTearDown(container.dispose);

    final trainings = await container.read(
      trainingsProvider('test-user').future,
    );

    expect(trainings, isNotEmpty);
    expect(trainings.length, 1);

    final t = trainings.first;
    expect(t.id, 'training-id-1');
    expect(t.selectedTables, equals([2, 3]));
    expect(t.score, closeTo(9.5, 0.01));
    expect(t.finishedAt, equals(DateTime.parse('2025-07-27T00:00:00.000')));

    expect(t.operations, hasLength(1));
    final op = t.operations.first;
    expect(op.expression, '2 x 3');
    expect(op.userAnswer, '6');
    expect(op.isCorrect, isTrue);
    expect(op.correctAnswer, isNull);
  });
}
