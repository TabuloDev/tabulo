// lib/features/training/infrastructure/dto/training_dto.dart 
import 'package:tabulo/features/training/domain/entities/operation.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';

class TrainingDto {
  final String id;
  final String userId;
  final double score;
  final DateTime finishedAt;
  final List<int> selectedTables;
  final List<Operation> operations;

  TrainingDto({
    required this.id,
    required this.userId,
    required this.score,
    required this.finishedAt,
    required this.selectedTables,
    required this.operations,
  });

  factory TrainingDto.fromJson(Map<String, dynamic> json) {
    final opsRaw = json['operations'] as List<dynamic>? ?? [];

    final operations = opsRaw.map((e) {
      return Operation.fromJson(e as Map<String, dynamic>);
    }).toList();

    return TrainingDto(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      score: (json['score'] as num).toDouble(),
      finishedAt: DateTime.parse(json['finishedAt'] as String),
      selectedTables: List<int>.from(json['selectedTables'] ?? []),
      operations: operations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'score': score,
      'finishedAt': finishedAt.toIso8601String(),
      'selectedTables': selectedTables,
      'operations': operations.map((op) => op.toJson()).toList(),
    };
  }

  Training toDomain() {
    return Training(
      id: id,
      questions: [],
      operations: operations,
      selectedTables: selectedTables,
      currentAnswer: '',
      currentIndex: 0,
      score: score,
      finishedAt: finishedAt,
    );
  }

  factory TrainingDto.fromDomain(Training training) {
    assert(training.score != null, 'training.score ne doit pas être null');
    assert(training.finishedAt != null, 'training.finishedAt ne doit pas être null');

    return TrainingDto(
      id: training.id,
      userId: training.id, // ⚠️ à adapter plus tard avec le vrai userId
      score: training.score ?? 0.0,
      finishedAt: training.finishedAt ?? DateTime.now(),
      selectedTables: training.selectedTables,
      operations: training.operations,
    );
  }

  @override
  String toString() {
    return 'TrainingDto(id: $id, userId: $userId, score: $score, finishedAt: $finishedAt, selectedTables: $selectedTables, operations: $operations)';
  }
}
