import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:icongen/core/architecture/data/result.dart';

class ImagenGenerationService {
  const ImagenGenerationService({
    required this.generativeModel,
    required this.editingModel,
  });

  final ImagenModel generativeModel;
  final ImagenModel editingModel;

  Future<Result<ImagenInlineImage>> generateImage(String prompt) async {
    try {
      final response = await generativeModel.generateImages(prompt);

      if (response.images.isEmpty) {
        return Result.failure(Exception('Failed to generate image'));
      }

      return Result.success(response.images.first);
    } catch (e) {
      return Result.failure(Exception('Error generating image: $e'));
    }
  }

  Future<Result<ImagenInlineImage>> processImage(Uint8List imageData) async {
    try {
      final response = await editingModel.editImage(
        [
          ImagenRawImage(
            image: ImagenInlineImage(
              bytesBase64Encoded: imageData,
              mimeType: 'image/png',
            ),
          ),
          ImagenBackgroundMask(),
        ],
        "remove all objects and background, don't touch the main icon",
        config: ImagenEditingConfig(editMode: ImagenEditMode.inpaintRemoval),
      );

      if (response.images.isEmpty) {
        return Result.failure(Exception('Error processing image'));
      }

      return Result.success(response.images.first);
    } catch (e) {
      return Result.failure(Exception('Error processing image: $e'));
    }
  }
}
