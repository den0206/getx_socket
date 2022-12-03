import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/language.dart';
import 'package:socket_flutter/src/model/response_api.dart';

class TranslateAPI extends APIBase {
  TranslateAPI() : super(EndPoint.translate);

  Future<ResponseAPI> getTranslate({
    required Map<int, String> text,
    required Language src,
    required Language tar,
  }) async {
    final texts = text.values.toList();
    final paragraphs = text.keys.map((i) => i.toString()).toList();
    final Map<String, dynamic> query = {
      "texts": texts,
      "paragraphs": paragraphs,
      "src": src.source_lang,
      "tar": tar.target_lang,
    };
    try {
      final Uri uri = setUri("/", query);

      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      rethrow;
    }
  }
}
