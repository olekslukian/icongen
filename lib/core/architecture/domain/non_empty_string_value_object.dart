import 'package:icongen/core/architecture/domain/value_object.dart';

class NonEmptyStringValueObject extends ValueObject<String> {
  NonEmptyStringValueObject(super.value);

  NonEmptyStringValueObject.invalid() : super.invalid();

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty || value.toLowerCase() == 'null') {
      return null;
    }

    return value;
  }
}
