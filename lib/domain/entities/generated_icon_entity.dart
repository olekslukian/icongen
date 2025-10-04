import 'dart:typed_data';

import 'package:icongen/core/architecture/domain/entity.dart';
import 'package:icongen/core/architecture/domain/validable.dart';
import 'package:icongen/core/architecture/domain/value_object.dart';

class GeneratedIconEntity extends Entity {
  GeneratedIconEntity.fromGenerationResult({
    required String id,
    required Uint8List data,
  }) : id = ValueObject(id),
       bytes = ValueObject(data);

  GeneratedIconEntity.invalid()
    : id = ValueObject.invalid(),
      bytes = ValueObject.invalid();

  final ValueObject<String> id;
  final ValueObject<Uint8List> bytes;
  @override
  List<IValidable> get props => [id, bytes];
}
