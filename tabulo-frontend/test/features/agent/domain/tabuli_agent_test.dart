import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/features/agent/domain/tabuli_agent.dart';

void main() {
  group('TabuliAgent.generateFeedback', () {
    test('retourne un message parfait si toutes les réponses sont justes', () {
      final message = TabuliAgent.generateFeedback(
        scoreSur10: 10.0,
        totalQuestions: 10,
        bonnesReponses: 10,
        tablesEnDifficulte: [],
      );
      expect(message, contains("Bravo"));
    });

    test('encourage si score entre 8 et 9.9', () {
      final message = TabuliAgent.generateFeedback(
        scoreSur10: 8.5,
        totalQuestions: 10,
        bonnesReponses: 8,
        tablesEnDifficulte: [],
      );
      expect(message, contains("Très bon travail"));
    });

    test('donne un conseil sur une table difficile si score entre 6 et 8', () {
      final message = TabuliAgent.generateFeedback(
        scoreSur10: 6.5,
        totalQuestions: 10,
        bonnesReponses: 7,
        tablesEnDifficulte: [7],
      );
      expect(message, contains("table de 7"));
    });

    test('encourage en cas de score faible', () {
      final message = TabuliAgent.generateFeedback(
        scoreSur10: 3.0,
        totalQuestions: 10,
        bonnesReponses: 3, // corrigé ici (au lieu de 4)
        tablesEnDifficulte: [6, 8],
      );
      expect(message.toLowerCase(), contains("ne te décourage pas"));
    });

    test('propose d’essayer si aucune question n’a été faite', () {
      final message = TabuliAgent.generateFeedback(
        scoreSur10: 0,
        totalQuestions: 0,
        bonnesReponses: 0,
        tablesEnDifficulte: [],
      );
      expect(message.toLowerCase(), contains("courage"));
    });
  });
}
