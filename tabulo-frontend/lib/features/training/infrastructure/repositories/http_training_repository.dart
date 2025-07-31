import 'package:dio/dio.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';

class HttpTrainingRepository implements TrainingRepository {
  final Dio dio;

  HttpTrainingRepository({required this.dio});

  @override
  Future<List<Training>> findAll({required String userId}) async {
    final response = await dio.get(
      '/api/trainings',
      queryParameters: {'userId': userId},
    );

    final List data = response.data as List;

    return data.map((json) => Training.fromJson(json)).toList();
  }

  @override
  Future<Training?> findById(String id) {
    throw UnimplementedError('findById() n’est pas encore implémenté');
  }

  @override
  Future<Training> save(Training training) {
    throw UnimplementedError('save() n’est pas encore implémenté');
  }

  @override
  Future<void> deleteAll() {
    throw UnimplementedError('deleteAll() n’est pas encore implémenté');
  }
}
