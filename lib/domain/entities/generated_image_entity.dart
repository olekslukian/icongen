import 'dart:typed_data';

import 'package:icongen/core/architecture/domain/bytes_value_object.dart';
import 'package:icongen/core/architecture/domain/entity.dart';
import 'package:icongen/core/architecture/domain/validable.dart';
import 'package:icongen/core/architecture/domain/value_object.dart';

class GeneratedImageEntity extends Entity {
  GeneratedImageEntity.fromGenerationResult({
    required String id,
    required Uint8List? data,
  }) : id = ValueObject(id),
       bytes = BytesValueObject(data);

  GeneratedImageEntity.invalid()
    : id = ValueObject.invalid(),
      bytes = BytesValueObject.invalid();

  final ValueObject<String> id;
  final BytesValueObject bytes;

  @override
  List<IValidable> get props => [id, bytes];
}
