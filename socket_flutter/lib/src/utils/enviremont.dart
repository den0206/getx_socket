import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';

class Enviroment {
  static String getHost() {
    final domainHost = FlutterConfig.get("DOMAIN_HOST");
    return kDebugMode ? "LOCALHOST:3000" : domainHost;
  }

  static String getMainUrl() {
    final domain = FlutterConfig.get("DOMAIN");
    return kDebugMode ? "http://localhost:3000" : domain;
  }
}
