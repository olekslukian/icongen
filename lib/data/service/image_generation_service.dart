import 'package:firebase_ai/firebase_ai.dart';
import 'package:icongen/core/architecture/data/result.dart';

class ImageGenerationService {
  const ImageGenerationService(this.ai);

  final GenerativeModel ai;

  Future<Result<InlineDataPart>> generateImage(Iterable<Content> prompt) async {
    try {
      final response = await ai.generateContent(
        prompt,
        generationConfig: GenerationConfig(
          responseModalities: [
            ResponseModalities.text,
            ResponseModalities.image,
          ],
        ),
      );

      if (response.inlineDataParts.isEmpty) {
        return Result.failure(Exception('Failed to generate image'));
      }

      return Result.success(response.inlineDataParts.first);
    } catch (e) {
      return Result.failure(Exception('Error generating image: $e'));
    }
  }
}
