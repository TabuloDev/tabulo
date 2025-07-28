// lib/features/training/domain/entities/training.dart

import 'package:uuid/uuid.dart';
import 'question.dart';
import 'operation.dart';

class Training {
  final String id;
  final List<Question> questions;
  final List<Operation> operations;
  final List<int> selectedTables;
  final String currentAnswer;
  final int currentIndex;
  final double? score;
  final DateTime? finishedAt;

  Training({
    String? id,
    required this.questions,
    required this.operations,
    required this.selectedTables,
    required this.currentAnswer,
    required this.currentIndex,
    required this.score,
    required this.finishedAt,
  }) : id = id ?? const Uuid().v4();

  Training copyWith({
    String? id,
    List<Question>? questions,
    List<Operation>? operations,
    List<int>? selectedTables,
    String? currentAnswer,
    int? currentIndex,
    double? score,
    DateTime? finishedAt,
  }) {
    return Training(
      id: id ?? this.id,
      questions: questions ?? this.questions,
      operations: operations ?? this.operations,
      selectedTables: selectedTables ?? this.selectedTables,
      currentAnswer: currentAnswer ?? this.currentAnswer,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }

  static Training empty() => Training(
    id: 'empty',
    questions: [],
    operations: [],
    selectedTables: [],
    currentAnswer: '',
    currentIndex: 0,
    score: null,
    finishedAt: null,
  );

  factory Training.fromJson(Map<String, dynamic> json) {
    final rawOps = json['operations'];
    final operations = <Operation>[];

    if (rawOps is List) {
      for (final rawOp in rawOps) {
        try {
          operations.add(Operation.fromJson(Map<String, dynamic>.from(rawOp)));
        } catch (_) {
          // Ignored
        }
      }
    }

    return Training(
      id: json['_id'] ?? const Uuid().v4(),
      questions: [],
      operations: operations,
      selectedTables: List<int>.from(json['selectedTables']),
      currentAnswer: '',
      currentIndex: 0,
      score: (json['score'] as num?)?.toDouble(),
      finishedAt: json['finishedAt'] != null
          ? DateTime.parse(json['finishedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'questions': [],
      'operations': operations.map((op) => op.toJson()).toList(),
      'selectedTables': selectedTables,
      'currentAnswer': currentAnswer,
      'currentIndex': currentIndex,
      'score': score,
      'finishedAt': finishedAt?.toIso8601String(),
    };
  }
}
