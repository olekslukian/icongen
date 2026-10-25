import 'package:firebase_ai/firebase_ai.dart';
import 'package:spritecraft/core/architecture/data/result.dart';
import 'package:spritecraft/core/architecture/domain/app_failure.dart';

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
        return const Result.failure(EmptyResponseFailure());
      }

      return Result.success(response.inlineDataParts.first);
    } catch (e) {
      return Result.failure(RemoteFailure('Error generating image: $e'));
    }
  }
}
