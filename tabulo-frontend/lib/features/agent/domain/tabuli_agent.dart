class TabuliAgent {
  /// Retourne un message d'encouragement ou de conseil basé sur les performances de l'enfant.
  static String generateFeedback({
    required double scoreSur10,
    required int totalQuestions,
    required int bonnesReponses,
    required List<int> tablesEnDifficulte, // ✅ nom corrigé sans accent
  }) {
    // Cas exceptionnel : entraînement non complété
    if (totalQuestions == 0) {
      return "Courage ! Tu peux essayer un entraînement pour t'améliorer.";
    }

    // Taux de réussite
    final taux = bonnesReponses / totalQuestions;

    if (taux == 1.0) {
      return "✨ Bravo ! Tu as tout réussi, c’est un sans faute !";
    } else if (taux >= 0.8) {
      return "👍 Très bon travail ! Encore un petit effort pour atteindre la perfection.";
    } else if (taux >= 0.6) {
      if (tablesEnDifficulte.isNotEmpty) {
        return "Bien joué ! Essaie de t'entraîner un peu plus sur la table de ${tablesEnDifficulte.join(', ')}.";
      }
      return "Pas mal du tout ! Tu peux progresser encore un peu avec un peu d'entraînement.";
    } else if (taux >= 0.4) {
      return "Tu es sur la bonne voie. Revois bien les tables de ${tablesEnDifficulte.join(', ')}.";
    } else {
      return "Ne te décourage pas. C’est en s’entraînant qu’on progresse !";
    }
  }
}
