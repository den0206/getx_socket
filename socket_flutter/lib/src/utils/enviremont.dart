import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:io' as io;

class Enviroment {
  static String getHost() {
    final domainHost = dotenv.env['DOMAIN_HOST'];

    final dubugHost =
        io.Platform.isAndroid ? "10.0.2.2:3000" : "LOCALHOST:3000";

    return kDebugMode ? dubugHost : domainHost!;
  }

  static String getMainUrl() {
    final domain = dotenv.env['DOMAIN'];

    final debugDomain = io.Platform.isAndroid
        ? "http://10.0.2.2:3000"
        : "http://localhost:3000";
    return kDebugMode ? debugDomain : domain!;
  }
}
