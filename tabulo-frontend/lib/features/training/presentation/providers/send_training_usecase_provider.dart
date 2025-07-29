import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:tabulo/features/training/application/usecases/send_training_usecase.dart';

final sendTrainingUseCaseProvider = Provider<SendTrainingUseCase>((ref) {
  final dio = Dio(); // ou ref.read(dioProvider) si tu en as un
  return SendTrainingUseCase(dio);
});
