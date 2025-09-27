import 'package:icongen/core/architecture/domain/non_empty_string_value_object.dart';
import 'package:icongen/data/service/icon_generation_service.dart';
import 'package:icongen/domain/entities/generated_icon_entity.dart';
import 'package:icongen/utils/icongen_logger.dart';

class IconGenerationRepository {
  const IconGenerationRepository(this.iconGenerationService);

  final IconGenerationService iconGenerationService;

  Future<GeneratedIconEntity> generateIcon(
    NonEmptyStringValueObject prompt,
  ) async {
    if (prompt.invalid) {
      return GeneratedIconEntity.invalid();
    }

    final result = await iconGenerationService.generateImage(prompt.getOr(''));

    return result.map(
      onSuccess: GeneratedIconEntity.fromGenerationResult,
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
