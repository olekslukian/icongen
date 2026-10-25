import 'dart:typed_data';

import 'package:spritecraft/core/architecture/domain/entity.dart';
import 'package:spritecraft/core/architecture/domain/sanitizers.dart';

final class GeneratedImageEntity extends Entity {
  const GeneratedImageEntity._({
    required super.id,
    required this.prompt,
    required this.bytes,
  });

  factory GeneratedImageEntity.fromGeneration({
    required String? id,
    required String? prompt,
    required Uint8List? data,
  }) {
    if (data == null || data.isEmpty) {
      throw const EntityValidationException('"bytes" cannot be empty');
    }

    return GeneratedImageEntity._(
      id: id.requireValid('id'),
      prompt: prompt.requireValid('prompt'),
      bytes: data,
    );
  }

  final String prompt;
  final Uint8List bytes;

  @override
  List<Object?> get props => [id, prompt];
}
