import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/country.dart';
import 'package:socket_flutter/src/model/response_api.dart';

class TranslateAPI extends APIBase {
  TranslateAPI() : super(EndPoint.translate);

  Future<ResponseAPI> getTranslate({
    required String text,
    required Country src,
    required Country tar,
  }) async {
    final Map<String, dynamic> query = {
      "text": text,
      "src": src.code,
      "tar": tar.code,
    };
    try {
      final Uri uri = Uri.http(host, "$endpoint/", query);

      return await getRequest(uri: uri);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
