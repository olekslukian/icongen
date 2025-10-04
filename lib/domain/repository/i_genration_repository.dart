import 'package:icongen/core/architecture/domain/prompt_value_object.dart';
import 'package:icongen/domain/entities/generated_icon_entity.dart';

abstract interface class IGenerationRepository {
  Future<GeneratedIconEntity> generateIcon(PromptValueObject prompt);
}
