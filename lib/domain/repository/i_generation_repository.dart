import 'package:spritecraft/core/architecture/data/result.dart';
import 'package:spritecraft/domain/entities/generated_image_entity.dart';

abstract interface class IGenerationRepository {
  Future<Result<GeneratedImageEntity>> generateImage(String prompt);
}
