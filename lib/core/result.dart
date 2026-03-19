import 'app_error.dart';

sealed class Result<T>{
  const Result();
}

class OK<T> extends Result<T>{
  final T data;
  const OK(this.data);
}

class Err<T> extends Result<T>{
  final AppError error;
  const Err(this.error);
}

