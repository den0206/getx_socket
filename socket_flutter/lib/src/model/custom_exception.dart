class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException(this._message, this._prefix);

  @override
  String toString() {
    // return "$_prefix$_message";
    var str = "$_prefix";
    if (_message != null) {
      str += _message;
    }

    return str;
  }
}

class FetchDataException extends CustomException {
  FetchDataException(message) : super(message, "Error During Communication: ");
}

class NotFoundException extends CustomException {
  NotFoundException(message) : super(message, "Not Found: ");
}

class ExceedLimitException extends CustomException {
  ExceedLimitException(message) : super(message, "ExceedLimit: ");
}

class URLTooLongException extends CustomException {
  URLTooLongException(message) : super(message, "Url is Too Long: ");
}

class TooManyRequestException extends CustomException {
  TooManyRequestException(message) : super(message, "Too Many Request: ");
}

class QuotaExceedException extends CustomException {
  QuotaExceedException(message) : super(message, "QuotaExceed: ");
}

class ResourceUnavailableException extends CustomException {
  ResourceUnavailableException(message)
    : super(message, "The Resource Unavailable: ");
}

class BadRequestException extends CustomException {
  BadRequestException(message) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException(message) : super(message, "Unauthorised: ");
}
