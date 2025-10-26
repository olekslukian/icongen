import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:icongen/core/ai_settings.dart';
import 'package:icongen/data/service/gemini_generation_service.dart';
import 'package:icongen/data/service/imagen_editing_service.dart';
import 'package:icongen/data/service/imagen_generation_service.dart';
import 'package:icongen/data/service/save_and_share_service.dart';
import 'package:icongen/domain/repository/gemini_generation_repository.dart';
import 'package:icongen/domain/repository/imagen_generation_repository.dart';
import 'package:icongen/domain/repository/save_and_share_repository.dart';
import 'package:icongen/presentation/home/state/image_generation_controller.dart';
import 'package:icongen/presentation/home/state/image_generation_state.dart';

//Models
final aiGeminiModelProvider = Provider<GenerativeModel>((ref) {
  final ai = FirebaseAI.vertexAI();

  return ai.generativeModel(
    model: AiSettings.geminiModelName,
    generationConfig: GenerationConfig(
      responseModalities: [ResponseModalities.text, ResponseModalities.image],
      temperature: AiSettings.temperature,
      topP: AiSettings.topP,
      topK: AiSettings.topK,
    ),
  );
});
final aiImagenGenerativeModelProvider = Provider<ImagenModel>((ref) {
  final ai = FirebaseAI.vertexAI();

  return ai.imagenModel(
    model: AiSettings.imagenGenerativeModelName,
    generationConfig: ImagenGenerationConfig(
      imageFormat: ImagenFormat.png(),
      negativePrompt: AiSettings.negativePromptParameters,
    ),
  );
});
final aiImagenEditingModelProvider = Provider<ImagenModel>((ref) {
  final ai = FirebaseAI.vertexAI();

  return ai.imagenModel(
    model: AiSettings.imagenEditingModelName,
    generationConfig: ImagenGenerationConfig(imageFormat: ImagenFormat.png()),
  );
});

//Services
final geminiGenerationServiceProvider = Provider<GeminiGenerationService>(
  (ref) => GeminiGenerationService(ref.watch(aiGeminiModelProvider)),
);
final imagenGenerationServiceProvider = Provider<ImagenGenerationService>(
  (ref) => ImagenGenerationService(ref.watch(aiImagenGenerativeModelProvider)),
);
final imagenEditingServiceProvider = Provider<ImagenEditingService>(
  (ref) => ImagenEditingService(ref.watch(aiImagenEditingModelProvider)),
);
final saveAndShareServiceProvider = Provider<SaveAndShareService>(
  (ref) => const SaveAndShareService(),
);

//Repositories
final geminiGenerationRepositoryProvider = Provider<GeminiGenerationRepository>(
  (ref) =>
      GeminiGenerationRepository(ref.watch(geminiGenerationServiceProvider)),
);
final imagenGenerationRepositoryProvider = Provider<ImagenGenerationRepository>(
  (ref) => ImagenGenerationRepository(
    iconGenerationService: ref.watch(imagenGenerationServiceProvider),
    imagenEditingService: ref.watch(imagenEditingServiceProvider),
  ),
);
final saveAndShareRepositoryProvider = Provider<SaveAndShareRepository>(
  (ref) => SaveAndShareRepository(ref.watch(saveAndShareServiceProvider)),
);

//Controllers
final geminiGenerationControllerProvider =
    StateNotifierProvider<ImageGenerationController, ImageGenerationState>(
      (ref) => ImageGenerationController(
        imageGenerationRepository: ref.watch(
          geminiGenerationRepositoryProvider,
        ),
        saveAndShareRepository: ref.watch(saveAndShareRepositoryProvider),
      ),
    );
