enum NetworkExceptionKind { offline, timeout, server, unexpected }

class NetworkException implements Exception {
  const NetworkException(this.kind, this.message);

  const NetworkException.offline()
    : this(
        NetworkExceptionKind.offline,
        'No internet connection. Check your connection and try again.',
      );

  const NetworkException.timeout()
    : this(
        NetworkExceptionKind.timeout,
        'The request took too long. Please try again.',
      );

  const NetworkException.server()
    : this(
        NetworkExceptionKind.server,
        'The food database is unavailable right now. Please try again.',
      );

  const NetworkException.unexpected()
    : this(
        NetworkExceptionKind.unexpected,
        'Could not complete the request. Please try again.',
      );

  final NetworkExceptionKind kind;
  final String message;

  @override
  String toString() => message;
}
