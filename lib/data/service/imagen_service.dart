import 'package:firebase_ai/firebase_ai.dart';
import 'package:icongen/core/architecture/data/result.dart';

class ImagenService {
  const ImagenService(this.imagenModel);

  final ImagenModel imagenModel;

  Future<Result<ImagenInlineImage>> generateImage(String prompt) async {
    final response = await imagenModel.generateImages(prompt);

    if (response.images.isNotEmpty) {
      return Result.success(response.images.first);
    }

    return Result.failure(Exception('Failed to generate image'));
  }
}
