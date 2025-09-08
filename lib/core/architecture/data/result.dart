typedef ResultSuccessMapper<T, R> = R Function(T data);
typedef ResultErrorMapper<R> = R Function(Exception error);

sealed class Result<T> {
  const Result._({T? data, Exception? error}) : _data = data, _error = error;

  factory Result.success(T data) => Success<T>(data);
  factory Result.failure(Exception error) => Failure<T>(error);

  final T? _data;
  final Exception? _error;

  R map<R>({
    required ResultSuccessMapper<T, R> onSuccess,
    required ResultErrorMapper<R> onError,
  }) {
    if (_data != null) {
      return onSuccess(_data as T);
    } else {
      return onError(_error ?? Exception('Something went wrong'));
    }
  }
}

final class Success<T> extends Result<T> {
  const Success(T data) : super._(data: data);
}

final class Failure<T> extends Result<T> {
  const Failure(Exception error) : super._(error: error);
}
