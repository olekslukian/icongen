sealed class AppFailure implements Exception {
  const AppFailure([this.message]);

  final String? message;
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(this.field, [super.message]);

  final String field;
}

final class InvalidResponseFailure extends AppFailure {
  const InvalidResponseFailure([super.message]);
}

final class EmptyResponseFailure extends AppFailure {
  const EmptyResponseFailure();
}

final class RemoteFailure extends AppFailure {
  const RemoteFailure([super.message]);
}

final class StorageFailure extends AppFailure {
  const StorageFailure([super.message]);
}
