import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spritecraft/core/ai_settings.dart';
import 'package:spritecraft/data/service/image_generation_service.dart';
import 'package:spritecraft/data/service/save_and_share_service.dart';
import 'package:spritecraft/domain/repository/image_generation_repository.dart';
import 'package:spritecraft/domain/repository/save_and_share_repository.dart';
import 'package:spritecraft/presentation/home/state/image_generation_controller.dart';
import 'package:spritecraft/presentation/home/state/image_generation_state.dart';

//Models
final aiModelProvider = Provider<GenerativeModel>((ref) {
  final ai = FirebaseAI.vertexAI();

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

//Services
final imageGenerationServiceProvider = Provider<ImageGenerationService>(
  (ref) => ImageGenerationService(ref.watch(aiModelProvider)),
);
final saveAndShareServiceProvider = Provider<SaveAndShareService>(
  (ref) => const SaveAndShareService(),
);

//Repositories
final imageGenerationRepositoryProvider = Provider<ImageGenerationRepository>(
  (ref) => ImageGenerationRepository(ref.watch(imageGenerationServiceProvider)),
);
final saveAndShareRepositoryProvider = Provider<SaveAndShareRepository>(
  (ref) => SaveAndShareRepository(ref.watch(saveAndShareServiceProvider)),
);

//Controllers
final geminiGenerationControllerProvider =
    StateNotifierProvider<ImageGenerationController, ImageGenerationState>(
      (ref) => ImageGenerationController(
        imageGenerationRepository: ref.watch(imageGenerationRepositoryProvider),
        saveAndShareRepository: ref.watch(saveAndShareRepositoryProvider),
      ),
    );
