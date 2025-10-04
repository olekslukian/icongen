import 'package:icongen/core/architecture/domain/prompt_value_object.dart';
import 'package:icongen/data/service/imagen_generation_service.dart';
import 'package:icongen/domain/entities/generated_icon_entity.dart';
import 'package:icongen/domain/repository/i_genration_repository.dart';
import 'package:icongen/utils/icongen_logger.dart';
import 'package:icongen/utils/image_processor.dart';

class ImagenGenerationRepository implements IGenerationRepository {
  const ImagenGenerationRepository(this.iconGenerationService);

  final ImagenGenerationService iconGenerationService;

  @override
  Future<GeneratedIconEntity> generateIcon(PromptValueObject prompt) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    if (prompt.invalid) {
      return GeneratedIconEntity.invalid();
    }

    final result = await iconGenerationService.generateImage(
      prompt.completePrompt,
    );

    return result.map(
      onSuccess: (data) {
        final originalBytes = data.bytesBase64Encoded;

        final processedBytes = ImageProcessor.removeBackground(originalBytes);

        return GeneratedIconEntity.fromGenerationResult(
          id: id,
          data: processedBytes ?? originalBytes,
        );
      },
      onError: (e) {
        IcongenLogger.error(
          'ImagenRepository.generateIcon: Failed to generate icon',
          error: e,
        );

        return GeneratedIconEntity.invalid();
      },
    );
  }
}
