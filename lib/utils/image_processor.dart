import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageProcessor {
  /// Removes light backgrounds and makes dark pixels pure black
  static Uint8List? removeBackground(
    Uint8List imageBytes, {
    int brightnessThreshold = 200,
  }) {
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      return imageBytes;
    }

    // Process each pixel
    for (final pixel in image) {
      final r = pixel.r.toInt();
      final g = pixel.g.toInt();
      final b = pixel.b.toInt();

      // Calculate brightness (0-255)
      final brightness = (r + g + b) / 3;

      if (brightness > brightnessThreshold) {
        // Bright pixel - likely background, make it transparent
        pixel.a = 0;
      } else {
        // Dark pixel - part of the icon, make it pure black
        pixel
          ..r = 0
          ..g = 0
          ..b = 0
          ..a = 255;
      }
    }

    return img.encodePng(image);
  }

  /// Alternative: Keep only very dark pixels, remove everything else
  static Uint8List? keepDarkOnly(
    Uint8List imageBytes, {
    int darkThreshold = 100,
  }) {
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      return imageBytes;
    }

    for (final pixel in image) {
      final brightness = (pixel.r + pixel.g + pixel.b) / 3;

      if (brightness > darkThreshold) {
        // Not dark enough - make transparent
        pixel.a = 0;
      } else {
        // Dark enough - make pure black
        pixel
          ..r = 0
          ..g = 0
          ..b = 0
          ..a = 255;
      }
    }

    return img.encodePng(image);
  }

  /// Most aggressive: Only keep nearly-black pixels
  static Uint8List? keepBlackOnly(
    Uint8List imageBytes, {
    int maxBrightness = 50,
  }) {
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      return imageBytes;
    }

    for (final pixel in image) {
      final r = pixel.r.toInt();
      final g = pixel.g.toInt();
      final b = pixel.b.toInt();

      // Check if all RGB components are dark
      if (r > maxBrightness || g > maxBrightness || b > maxBrightness) {
        // At least one component is too bright - remove it
        pixel.a = 0;
      } else {
        // All components are dark - make it pure black
        pixel
          ..r = 0
          ..g = 0
          ..b = 0
          ..a = 255;
      }
    }

    return img.encodePng(image);
  }
}
