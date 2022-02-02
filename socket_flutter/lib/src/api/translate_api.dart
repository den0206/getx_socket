import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/language.dart';
import 'package:socket_flutter/src/model/response_api.dart';

class TranslateAPI extends APIBase {
  TranslateAPI() : super(EndPoint.translate);

  Future<ResponseAPI> getTranslate({
    required String text,
    required Language src,
    required Language tar,
  }) async {
    final Map<String, dynamic> query = {
      "text": text,
      "src": src.code,
      "tar": tar.code,
    };
    try {
      final Uri uri = Uri.http(host, "$endpoint/", query);

      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
