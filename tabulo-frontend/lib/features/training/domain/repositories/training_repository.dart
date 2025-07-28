import '../entities/training.dart';

abstract class TrainingRepository {
  Future<Training> save(Training training);
  Future<Training?> findById(String id);
  Future<void> deleteAll();

  /// 🔥 Nouvelle méthode pour récupérer tous les entraînements d’un utilisateur
  Future<List<Training>> findAll({required String userId});
}
