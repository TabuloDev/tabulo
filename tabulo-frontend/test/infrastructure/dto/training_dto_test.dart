import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/features/training/infrastructure/dto/training_dto.dart';

void main() {
  group('TrainingDto', () {
    test('fromJson should parse correctly', () {
      // given
      final json = {
        '_id': 'abc123',
        'userId': 'user456',
        'score': 8.5,
        'finishedAt': '2025-07-28T10:45:00.000Z',
      };

      // when
      final dto = TrainingDto.fromJson(json);

      // then
      expect(dto.id, 'abc123');
      expect(dto.userId, 'user456');
      expect(dto.score, 8.5);
      expect(dto.finishedAt, DateTime.parse('2025-07-28T10:45:00.000Z'));
    });
  });
}
