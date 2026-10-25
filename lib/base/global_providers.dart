import 'package:firebase_ai/firebase_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spritecraft/core/ai_settings.dart';
import 'package:spritecraft/data/service/image_generation_service.dart';
import 'package:spritecraft/data/service/save_and_share_service.dart';
import 'package:spritecraft/domain/repository/i_generation_repository.dart';
import 'package:spritecraft/domain/repository/i_save_and_share_repository.dart';
import 'package:spritecraft/domain/repository/image_generation_repository.dart';
import 'package:spritecraft/domain/repository/save_and_share_repository.dart';

part 'global_providers.g.dart';

@Riverpod(keepAlive: true)
GenerativeModel aiModel(Ref ref) {
  final ai = FirebaseAI.agentPlatform(location: 'us-central1');

  return ai.generativeModel(
    model: AiSettings.modelName,
    generationConfig: GenerationConfig(
      responseModalities: [ResponseModalities.text, ResponseModalities.image],
      temperature: AiSettings.temperature,
      topP: AiSettings.topP,
      topK: AiSettings.topK,
    ),
  );
}

@Riverpod(keepAlive: true)
ImageGenerationService imageGenerationService(Ref ref) =>
    ImageGenerationService(ref.watch(aiModelProvider));

@Riverpod(keepAlive: true)
SaveAndShareService saveAndShareService(Ref ref) =>
    const SaveAndShareService();

@Riverpod(keepAlive: true)
IGenerationRepository imageGenerationRepository(Ref ref) =>
    ImageGenerationRepository(ref.watch(imageGenerationServiceProvider));

@Riverpod(keepAlive: true)
ISaveAndShareRepository saveAndShareRepository(Ref ref) =>
    SaveAndShareRepository(ref.watch(saveAndShareServiceProvider));
