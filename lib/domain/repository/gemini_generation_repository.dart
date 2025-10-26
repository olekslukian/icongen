import 'package:icongen/core/architecture/domain/prompt_value_object.dart';
import 'package:icongen/data/service/gemini_generation_service.dart';
import 'package:icongen/domain/entities/generated_image_entity.dart';
import 'package:icongen/domain/repository/i_genration_repository.dart';
import 'package:icongen/utils/icongen_logger.dart';

class GeminiGenerationRepository implements IGenerationRepository {
  const GeminiGenerationRepository(this.iconGenerationService);

  final GeminiGenerationService iconGenerationService;

  @override
  Future<GeneratedImageEntity> generateImage(PromptValueObject prompt) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    if (prompt.invalid) {
      return GeneratedImageEntity.invalid();
    }

    final result = await iconGenerationService.generateImage(
      prompt.completePromptAsContent,
    );

    return result.map(
      onSuccess: (data) {
        return GeneratedImageEntity.fromGenerationResult(
          id: id,
          data: data.bytes,
        );
      },
      onError: (e) {
        IcongenLogger.error(
          'GeminiGenerationRepository.generateIcon: Failed to generate icon',
          error: e,
        );

        return GeneratedImageEntity.invalid();
      },
    );
  }
}
