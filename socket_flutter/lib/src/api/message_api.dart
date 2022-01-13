import 'package:socket_flutter/src/model/response_api.dart';
import 'api_base.dart';

class MessageAPI extends APIBase {
  MessageAPI() : super(EndPoint.message);

  Future<ResponseAPI> sendMessage(
      {required Map<String, dynamic> message}) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/");
      final String bodyParams = json.encode(message);

      final res = await client.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> loadMessage(
      {required String chatRoomId, int? limit, String? nextCursor}) async {
    final Map<String, dynamic> query = {
      "limit": limit.toString(),
      "cursor": nextCursor,
    };

    try {
      final Uri uri = Uri.http(
        host,
        "$endpoint/$chatRoomId",
        query,
      );

      final res = await client.get(uri, headers: headers);
      final decode = json.decode((res.body));

      return ResponseAPI.fromMap(decode);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> updateReadStatus(
      String messageId, Map<String, dynamic> readBody) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/updateRead/$messageId");
      final String bodyParams = json.encode(readBody);

      final res = await client.put(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> deleteMessage(String messageId) async {
    if (!checkToken()) {
      return ResponseAPI(status: false, data: null, message: "No Token");
    }
    try {
      final Uri uri = Uri.http(host, "$endpoint/$messageId");

      final res = await client.delete(uri, headers: headers);
      final data = json.decode(res.body);
      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }
}
