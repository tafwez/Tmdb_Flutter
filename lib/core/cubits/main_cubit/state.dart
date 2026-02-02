import '../../../data/genres/genres.dart';
abstract class ApiState<T> {}

class ApiInitial<T> extends ApiState {}

class ApiLoading<T> extends ApiState {}

class ApiLoaded<T> extends ApiState {
  final T data;

  ApiLoaded(this.data);
}


class ApiError<T> extends ApiState {
  final String message;

  ApiError(this.message);
}
