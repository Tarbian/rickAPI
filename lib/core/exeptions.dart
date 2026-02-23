class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class NetworkException extends AppException {
  const NetworkException()
      : super('No internet connection. Please check your network.');
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred.']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found.']);
}
