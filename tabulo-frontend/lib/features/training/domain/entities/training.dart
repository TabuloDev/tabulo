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

  /// Factory pour désérialiser un Training depuis du JSON
  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['_id'] ?? const Uuid().v4(),
      questions: [], // Les questions ne sont pas renvoyées par le backend
      operations: (json['operations'] as List<dynamic>)
          .map((op) => Operation.fromJson(op))
          .toList(),
      selectedTables: List<int>.from(json['selectedTables']),
      currentAnswer: '', // Non renvoyé, car pas utile en historique
      currentIndex: 0,   // Idem
      score: (json['score'] as num?)?.toDouble(),
      finishedAt: json['finishedAt'] != null
          ? DateTime.parse(json['finishedAt'])
          : null,
    );
  }

  /// Méthode utile si tu veux renvoyer un Training vers le backend
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'questions': [], // volontairement vide
      'operations': operations.map((op) => op.toJson()).toList(),
      'selectedTables': selectedTables,
      'currentAnswer': currentAnswer,
      'currentIndex': currentIndex,
      'score': score,
      'finishedAt': finishedAt?.toIso8601String(),
    };
  }
}
