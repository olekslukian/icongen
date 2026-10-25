class EntityValidationException implements Exception {
  const EntityValidationException(this.message);

  final String message;
}

extension StringSanitizer on String? {
  String sanitize({String fallback = ''}) {
    final value = this?.trim();
    return value == null || value.isEmpty || value.toLowerCase() == 'null'
        ? fallback
        : value;
  }

  String requireValid(String field) {
    final value = sanitize();
    if (value.isEmpty) {
      throw EntityValidationException('"$field" is required');
    }
    return value;
  }
}
