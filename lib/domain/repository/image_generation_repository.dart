import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:spritecraft/core/architecture/data/result.dart';
import 'package:spritecraft/core/architecture/domain/app_failure.dart';
import 'package:spritecraft/core/architecture/domain/sanitizers.dart';
import 'package:spritecraft/data/service/image_generation_service.dart';
import 'package:spritecraft/domain/entities/generated_image_entity.dart';
import 'package:spritecraft/domain/repository/i_generation_repository.dart';
import 'package:spritecraft/utils/spritecraft_logger.dart';

class ImageGenerationRepository implements IGenerationRepository {
  const ImageGenerationRepository(this.iconGenerationService);

  final ImageGenerationService iconGenerationService;

  @override
  Future<Result<GeneratedImageEntity>> generateImage(String prompt) async {
    final result = await iconGenerationService.generateImage([
      Content.text(prompt),
    ]);

    return switch (result) {
      Failure(:final failure) => _logged(failure),
      Success(:final data) => _toEntity(prompt, data.bytes),
    };
  }

  Result<GeneratedImageEntity> _toEntity(String prompt, Uint8List bytes) {
    try {
      return Result.success(
        GeneratedImageEntity.fromGeneration(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          prompt: prompt,
          data: bytes,
        ),
      );
    } on EntityValidationException catch (error) {
      return _logged(InvalidResponseFailure(error.message));
    }
  }

  Result<T> _logged<T>(AppFailure failure) {
    SpriteCraftLogger.error(
      'ImageGenerationRepository.generateImage: Failed to generate image',
      error: failure,
    );
    return Result.failure(failure);
  }
}
