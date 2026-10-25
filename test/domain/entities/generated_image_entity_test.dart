import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:spritecraft/core/architecture/domain/sanitizers.dart';
import 'package:spritecraft/domain/entities/generated_image_entity.dart';

void main() {
  group('GeneratedImageEntity.fromGeneration', () {
    test('creates a valid image entity', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final image = GeneratedImageEntity.fromGeneration(
        id: 'image-1',
        prompt: 'blue sprite',
        data: bytes,
      );

      expect(image.id, 'image-1');
      expect(image.prompt, 'blue sprite');
      expect(image.bytes, same(bytes));
    });

    test('rejects empty image bytes', () {
      expect(
        () => GeneratedImageEntity.fromGeneration(
          id: 'image-1',
          prompt: 'blue sprite',
          data: Uint8List(0),
        ),
        throwsA(isA<EntityValidationException>()),
      );
    });

    test('rejects a blank id', () {
      expect(
        () => GeneratedImageEntity.fromGeneration(
          id: '  ',
          prompt: 'blue sprite',
          data: Uint8List.fromList([1]),
        ),
        throwsA(isA<EntityValidationException>()),
      );
    });
  });
}
