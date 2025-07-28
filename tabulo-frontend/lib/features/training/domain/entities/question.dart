// lib/features/training/domain/entities/question.dart

class Question {
  final int operand1;
  final int operand2;

  String? userAnswer;
  bool? isCorrect;

  Question(this.operand1, this.operand2);

  int get answer => operand1 * operand2;

  @override
  String toString() => '$operand1 × $operand2';
}

// Fonction utilitaire pour générer une liste de questions à partir de tables sélectionnées
List<Question> generateQuestions(List<int> tables, {int count = 10}) {
  final List<Question> all = [];

  for (final table in tables) {
    for (int i = 1; i <= 10; i++) {
      all.add(Question(table, i));
    }
  }

  all.shuffle();
  return all.take(count).toList();
}
