import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:io' as io;

import '../../main.dart';

class Enviroment {
  static String getHost() {
    final domainHost = dotenv.env['DOMAIN_HOST'];
    if (useMain) return domainHost!;

    final dubugHost =
        io.Platform.isAndroid ? "10.0.2.2:3000" : "LOCALHOST:3000";

    return kDebugMode ? dubugHost : domainHost!;
  }

  static String getMainUrl() {
    final domain = dotenv.env['DOMAIN'];
    if (useMain) return domain!;

    final debugDomain = io.Platform.isAndroid
        ? "http://10.0.2.2:3000"
        : "http://localhost:3000";
    return kDebugMode ? debugDomain : domain!;
  }
}
