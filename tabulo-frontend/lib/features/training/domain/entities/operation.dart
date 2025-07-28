// lib/features/training/domain/entities/operation.dart

class Operation {
  final String expression;
  final String userAnswer;
  final bool isCorrect;
  final int? correctAnswer;

  const Operation({
    required this.expression,
    required this.userAnswer,
    required this.isCorrect,
    this.correctAnswer,
  });

  factory Operation.fromJson(Map<String, dynamic> json) {
    final rawUserAnswer = json['userAnswer'];

    return Operation(
      expression: json['expression'] as String,
      userAnswer: rawUserAnswer.toString(),
      isCorrect: json['isCorrect'] as bool,
      correctAnswer: json['correction'] != null
          ? json['correction'] as int
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expression': expression,
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
      'correction': correctAnswer,
    };
  }
}
