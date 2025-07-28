import 'package:collection/collection.dart';
import '../../domain/entities/training.dart';
import '../../domain/repositories/training_repository.dart';

class InMemoryTrainingRepository implements TrainingRepository {
  final List<Training> _trainings = [];

  InMemoryTrainingRepository();

  @override
  Future<Training> save(Training training) async {
    final index = _trainings.indexWhere((t) => t.id == training.id);
    if (index >= 0) {
      _trainings[index] = training;
    } else {
      _trainings.add(training);
    }
    return training;
  }

  @override
  Future<List<Training>> findAll({required String userId}) async {
    return _trainings.where((t) => t.id.startsWith(userId)).toList();
  }

  @override
  Future<Training?> findById(String id) async {
    return _trainings.firstWhereOrNull((t) => t.id == id);
  }

  @override
  Future<void> deleteAll() async {
    _trainings.clear();
  }
}

// ✅ Fournisseur global à utiliser partout dans l'app
final inMemoryTrainingRepository = _createInstance();

InMemoryTrainingRepository _createInstance() {
  return InMemoryTrainingRepository();
}
