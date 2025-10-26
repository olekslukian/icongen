import 'package:icongen/core/architecture/domain/prompt_value_object.dart';
import 'package:icongen/domain/entities/generated_image_entity.dart';

abstract interface class IGenerationRepository {
  Future<GeneratedImageEntity> generateImage(PromptValueObject prompt);
}
