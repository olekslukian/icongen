abstract interface class IValidable {
  bool get valid;
  bool get invalid;
}

extension IterableValidableX<T extends IValidable> on Iterable<T> {
  bool get everyValid => every((e) => e.valid);

  Iterable<T> get whereValid => where((e) => e.valid);
}
