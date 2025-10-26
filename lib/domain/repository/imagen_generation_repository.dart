import 'package:icongen/core/architecture/domain/prompt_value_object.dart';
import 'package:icongen/data/service/imagen_editing_service.dart';
import 'package:icongen/data/service/imagen_generation_service.dart';
import 'package:icongen/domain/entities/generated_image_entity.dart';
import 'package:icongen/domain/repository/i_genration_repository.dart';
import 'package:icongen/utils/icongen_logger.dart';

class ImagenGenerationRepository implements IGenerationRepository {
  const ImagenGenerationRepository({
    required this.iconGenerationService,
    required this.imagenEditingService,
  });

  final ImagenGenerationService iconGenerationService;
  final ImagenEditingService imagenEditingService;

  @override
  Future<GeneratedImageEntity> generateImage(PromptValueObject prompt) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    if (prompt.invalid) {
      return GeneratedImageEntity.invalid();
    }

    final result = await iconGenerationService.generateImage(
      prompt.completePrompt,
    );

    return result.map(
      onSuccess: (data) {
        return GeneratedImageEntity.fromGenerationResult(
          id: id,
          data: data.bytesBase64Encoded,
        );
      },
      onError: (e) {
        IcongenLogger.error(
          'ImagenGenerationRepository.generateIcon: Failed to generate icon',
          error: e,
        );

        return GeneratedImageEntity.invalid();
      },
    );
  }
}
