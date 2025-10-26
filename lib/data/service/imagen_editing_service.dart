import 'package:firebase_ai/firebase_ai.dart';
import 'package:icongen/core/architecture/data/result.dart';

class ImagenEditingService {
  const ImagenEditingService(this.ai);

  final ImagenModel ai;

  Future<Result<ImagenInlineImage>> editImage({
    required List<ImagenReferenceImage> references,
    required String prompt,
    required ImagenEditMode editMode,
  }) async {
    try {
      final response = await ai.editImage(
        references,
        prompt,
        config: ImagenEditingConfig(editSteps: 50, editMode: editMode),
      );

      if (response.images.isEmpty) {
        return Result.failure(Exception('Failed to process image'));
      }

      return Result.success(response.images.first);
    } catch (e) {
      return Result.failure(Exception('Error processing image: $e'));
    }
  }
}
