import 'package:flutter/foundation.dart';

class Enviroment {
  static const host = kDebugMode ? "LOCALHOST:3000" : "RELEASE";
  static const main = kDebugMode ? "http://localhost:3000" : "RELEASE";
}
