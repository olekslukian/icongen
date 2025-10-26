import 'dart:typed_data';

import 'package:icongen/core/architecture/domain/value_object.dart';

class BytesValueObject extends ValueObject<Uint8List> {
  BytesValueObject(super.value);

  BytesValueObject.invalid() : super.invalid();

  Uint8List get get => getOr(Uint8List(0));

  @override
  Uint8List? validate(Uint8List? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }
}
