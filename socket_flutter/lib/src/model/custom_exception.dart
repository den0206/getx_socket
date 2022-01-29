class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException(this._message, this._prefix);

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

class BadRequestException extends CustomException {
  BadRequestException(message) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException(message) : super(message, "Unauthorised: ");
}
