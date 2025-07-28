import 'package:tabulo/features/training/domain/entities/training.dart';

class TrainingDto {
  final String id;
  final String userId;
  final double score;
  final DateTime finishedAt;

  TrainingDto({
    required this.id,
    required this.userId,
    required this.score,
    required this.finishedAt,
  });

  factory TrainingDto.fromJson(Map<String, dynamic> json) {
    return TrainingDto(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      score: (json['score'] as num).toDouble(),
      finishedAt: DateTime.parse(json['finishedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'score': score,
      'finishedAt': finishedAt.toIso8601String(),
    };
  }

  /// Convertit ce DTO en entité de domaine Training
  Training toDomain() {
    return Training(
      id: id,
      questions: [],
      operations: [],
      selectedTables: [],
      currentAnswer: '',
      currentIndex: 0,
      score: score,
      finishedAt: finishedAt,
    );
  }
}
