import 'package:firebase_ai/firebase_ai.dart';
import 'package:icongen/core/architecture/data/result.dart';

class IconGenerationService {
  const IconGenerationService(this.ai);

  final GenerativeModel ai;

  Future<Result<InlineDataPart>> generateImage(String prompt) async {
    try {
      final response = await ai.generateContent(
        _buildIconPrompt(prompt),
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

  Iterable<Content> _buildIconPrompt(String prompt) {
    const iconRequirements = [
      'minimal flat icon',
      'single solid color',
      'transparent background',
      'no text or labels',
      'no shadows or gradients',
      'clean vector style',
      'material design inspired',
      'simple geometric shapes',
      'no decorative elements',
    ];

    const negativeElements = [
      'no background',
      'no text',
      'no shadows',
      'no gradients',
      'no 3D effects',
      'no realistic textures',
      'no multiple colors',
      'no decorations',
    ];

    final completePrompt =
        '''
Create a $prompt as a ${iconRequirements.join(', ')}.
Style requirements: ${negativeElements.join(', ')}.
The icon should be suitable for user interface design, similar to Material Icons or Feather Icons.
'''
            .trim();

    return [Content.text(completePrompt)];
  }
}
