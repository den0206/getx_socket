import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/response_api.dart';

class GropuAPI extends APIBase {
  GropuAPI() : super(EndPoint.group);

  Future<ResponseAPI> createGroup(Map<String, dynamic> group) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/");
      final String bodyParams = json.encode(group);

      final res = await client.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }
}
