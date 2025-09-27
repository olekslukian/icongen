import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:icongen/core/architecture/domain/entity.dart';
import 'package:icongen/core/architecture/domain/validable.dart';
import 'package:icongen/core/architecture/domain/value_object.dart';

class GeneratedIconEntity extends Entity {
  GeneratedIconEntity.fromGenerationResult(InlineDataPart data)
    : id = ValueObject(DateTime.now().millisecondsSinceEpoch.toString()),
      bytes = ValueObject(data.bytes);

  GeneratedIconEntity.invalid()
    : id = ValueObject.invalid(),
      bytes = ValueObject.invalid();

  final ValueObject<String> id;
  final ValueObject<Uint8List> bytes;
  @override
  List<IValidable> get props => [id, bytes];
}
