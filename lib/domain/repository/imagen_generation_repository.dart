import 'dart:typed_data';

import 'package:icongen/core/architecture/domain/prompt_value_object.dart';
import 'package:icongen/data/service/imagen_generation_service.dart';
import 'package:icongen/domain/entities/generated_icon_entity.dart';
import 'package:icongen/domain/repository/i_genration_repository.dart';
import 'package:icongen/utils/icongen_logger.dart';

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
        return GeneratedIconEntity.fromGenerationResult(
          id: id,
          data: data.bytesBase64Encoded,
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

  @override
  Future<GeneratedIconEntity> processIcon(GeneratedIconEntity icon) async {
    if (icon.invalid) {
      return GeneratedIconEntity.invalid();
    }

    final result = await iconGenerationService.processImage(
      icon.bytes.getOr(Uint8List(0)),
    );

    return result.map(
      onSuccess: (data) {
        return GeneratedIconEntity.fromGenerationResult(
          id: icon.id.getOr(''),
          data: data.bytesBase64Encoded,
        );
      },
      onError: (e) {
        IcongenLogger.error(
          'ImagenRepository.processIconData: Failed to process icon data',
          error: e,
        );

        return GeneratedIconEntity.invalid();
      },
    );
  }
}
