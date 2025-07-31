import 'package:dio/dio.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/infrastructure/dto/training_dto.dart';

class SendTrainingUseCase {
  final Dio dio;

  SendTrainingUseCase(this.dio);

  Future<bool> call(Training training) async {
    final dto = TrainingDto.fromDomain(training);
    final url = '/api/trainings';

    try {
      final response = await dio.post(url, data: dto.toJson());
      return response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }
}
