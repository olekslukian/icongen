import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icongen/core/constants.dart';
import 'package:icongen/data/service/imagen_service.dart';
import 'package:icongen/domain/repository/imagen_repository.dart';

final imagenModelProvider = Provider<ImagenModel>((ref) {
  final ai = FirebaseAI.googleAI();
  return ai.imagenModel(model: Constants.imagenModelName);
});

final imagenServiceProvider = Provider<ImagenService>((ref) {
  return ImagenService(ref.watch(imagenModelProvider));
});

final imagenRepositoryProvider = Provider<ImagenRepository>((ref) {
  return ImagenRepository(ref.watch(imagenServiceProvider));
});
