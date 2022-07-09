import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:io' as io;

import '../../main.dart';

class Enviroment {
  static String getHost() {
    const flavor = String.fromEnvironment('FLAVOR');
    print(flavor);

    if (useMain) {
      String domainHost;

      switch (flavor) {
        case "dev":
        case "stg":
          domainHost = dotenv.env['STAGING_HOST']!;
          break;
        case "prod":
          domainHost = dotenv.env['PRODUCT_HOST']!;

          break;
        default:
          assert(false);
          domainHost = "";
      }

      return domainHost;
    } else {
      return io.Platform.isAndroid ? "10.0.2.2:3000" : "LOCALHOST:3000";
    }
  }

  static String getMainUrl() {
    const flavor = String.fromEnvironment('FLAVOR');
    print(flavor);

    if (useMain) {
      String domainHost;

      switch (flavor) {
        case "dev":
        case "stg":
          domainHost = dotenv.env['STAGING_SOCKET']!;
          break;
        case "prod":
          domainHost = dotenv.env['PRODUCT_SOCKET']!;

          break;
        default:
          assert(false);
          domainHost = "";
      }

      return domainHost;
    } else {
      return io.Platform.isAndroid
          ? "http://10.0.2.2:3000"
          : "http://localhost:3000";
    }
  }
}
