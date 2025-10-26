import 'package:firebase_ai/firebase_ai.dart';
import 'package:icongen/core/architecture/data/result.dart';

class ImagenGenerationService {
  const ImagenGenerationService(this.ai);

  final ImagenModel ai;

  Future<Result<ImagenInlineImage>> generateImage(String prompt) async {
    try {
      final response = await ai.generateImages(prompt);

      if (response.images.isEmpty) {
        return Result.failure(Exception('Failed to generate image'));
      }

      return Result.success(response.images.first);
    } catch (e) {
      return Result.failure(Exception('Error generating image: $e'));
    }
  }
}
