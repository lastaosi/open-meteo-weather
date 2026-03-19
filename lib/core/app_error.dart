enum AppErrorType {network,server,parsing,unknown}

class AppError{
  final AppErrorType type;
  final String message;
  final int? statusCode;

  AppError(this.type, this.message, {this.statusCode});

  @override
  String toString() => 'AppError($type,$message,status = $statusCode)';
}