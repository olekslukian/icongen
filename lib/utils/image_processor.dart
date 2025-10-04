import 'dart:typed_data';

import 'package:image/image.dart' as img;

class ImageProcessor {
  static Uint8List? removeBackground(
    Uint8List imageBytes, {
    int threshold = 80,
  }) {
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      return imageBytes;
    }

    for (final pixel in image) {
      if (pixel.r < threshold && pixel.g < threshold && pixel.b < threshold) {
        pixel
          ..r = 0
          ..g = 0
          ..b = 0
          ..a = 255;
      } else {
        pixel.a = 0;
      }
    }

    return img.encodePng(image);
  }
}
