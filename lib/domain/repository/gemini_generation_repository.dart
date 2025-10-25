import 'package:icongen/core/architecture/domain/prompt_value_object.dart';
import 'package:icongen/data/service/gemini_generation_service.dart';
import 'package:icongen/domain/entities/generated_icon_entity.dart';
import 'package:icongen/domain/repository/i_genration_repository.dart';
import 'package:icongen/utils/icongen_logger.dart';

class GeminiGenerationRepository implements IGenerationRepository {
  const GeminiGenerationRepository(this.iconGenerationService);

  final GeminiGenerationService iconGenerationService;

  @override
  Future<GeneratedIconEntity> generateIcon(PromptValueObject prompt) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    if (prompt.invalid) {
      return GeneratedIconEntity.invalid();
    }

    final result = await iconGenerationService.generateImage(
      prompt.completePromptAsContent,
    );

    return result.map(
      onSuccess: (data) {
        return GeneratedIconEntity.fromGenerationResult(
          id: id,
          data: data.bytes,
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
  Future<GeneratedIconEntity> processIcon(GeneratedIconEntity icon) {
    // TODO: implement processIcon
    throw UnimplementedError();
  }
}
