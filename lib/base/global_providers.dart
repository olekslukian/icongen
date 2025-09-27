import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:icongen/core/ai_settings.dart';
import 'package:icongen/data/service/icon_generation_service.dart';
import 'package:icongen/domain/repository/icon_generation_repository.dart';
import 'package:icongen/presentation/home/state/icon_generation_controller.dart';
import 'package:icongen/presentation/home/state/icon_generation_state.dart';

final aiModelProvider = Provider<GenerativeModel>((ref) {
  final ai = FirebaseAI.googleAI();
  return ai.generativeModel(
    model: AiSettings.modelName,
    generationConfig: GenerationConfig(
      responseModalities: [ResponseModalities.text, ResponseModalities.image],
      temperature: AiSettings.temperature,
      topP: AiSettings.topP,
      topK: AiSettings.topK,
    ),
  );
});

final iconGenerationServiceProvider = Provider<IconGenerationService>((ref) {
  return IconGenerationService(ref.watch(aiModelProvider));
});

final iconGenerationRepositoryProvider = Provider<IconGenerationRepository>((
  ref,
) {
  return IconGenerationRepository(ref.watch(iconGenerationServiceProvider));
});

final iconGenerationControllerProvider =
    StateNotifierProvider<IconGenerationController, IconGenerationState>((ref) {
      return IconGenerationController(
        ref.watch(iconGenerationRepositoryProvider),
      );
    });
