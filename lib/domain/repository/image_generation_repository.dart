import 'dart:typed_data';
import 'dart:ui';

import 'package:image_background_remover/image_background_remover.dart';
import 'package:spritecraft/core/architecture/domain/prompt_value_object.dart';
import 'package:spritecraft/data/service/image_generation_service.dart';
import 'package:spritecraft/domain/entities/generated_image_entity.dart';
import 'package:spritecraft/domain/repository/i_generation_repository.dart';
import 'package:spritecraft/utils/spritecraft_logger.dart';

class ImageGenerationRepository implements IGenerationRepository {
  const ImageGenerationRepository(this.iconGenerationService);

  final ImageGenerationService iconGenerationService;

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
      onSuccess: (data) async {
        final processedBytes = await _removeBackground(data.bytes);

        return GeneratedImageEntity.fromGenerationResult(
          id: id,
          data: processedBytes,
        );
      },
      onError: (e) {
        SpriteCraftLogger.error(
          'ImageGenerationRepository.generateIcon: Failed to generate icon',
          error: e,
        );

        return GeneratedImageEntity.invalid();
      },
    );
  }

  Future<Uint8List?> _removeBackground(Uint8List imageBytes) async {
    final processedImage = await BackgroundRemover.instance.removeBg(
      threshold: 0.6,
      imageBytes,
    );

    final byteData = await processedImage.toByteData(
      format: ImageByteFormat.png,
    );

    return byteData?.buffer.asUint8List();
  }
}
