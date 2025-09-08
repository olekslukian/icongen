import 'package:icongen/core/architecture/domain/value_object_base.dart';

class ValueObject<T extends Object> extends ValueObjectBase<T> {
  ValueObject(T? value) {
    this.value = validate(value);
  }

  ValueObject.invalid() {
    value = null;
  }

  T? validate(T? value) => value;
}
