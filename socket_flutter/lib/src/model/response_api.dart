class ResponseAPI {
  final bool status;
  String? message;
  dynamic data;

  ResponseAPI({required this.status, required this.data, this.message});

  factory ResponseAPI.fromMap(Map<String, dynamic> map) {
    return ResponseAPI(
      status: map['status'],
      data: map['data'],
      message: map['message'],
    );
  }

  @override
  String toString() =>
      'ResponseAPI(status: $status, message: $message, data: $data)';
}

// final invalidError =
//     ResponseAPI(status: false, data: null, message: "Invalid Error");

// ResponseAPI catchAPIError([String message = "Invalid Error"]) {
//   /// show Allert
//   showError(message);

//   return ResponseAPI(
//     status: false,
//     data: null,
//     message: message,
//   );
// }
