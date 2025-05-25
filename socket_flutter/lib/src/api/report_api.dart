import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/response_api.dart';

class ReportAPI extends APIBase {
  ReportAPI() : super(EndPoint.report);

  Future<ResponseAPI> sendReport({
    required Map<String, dynamic> reportData,
  }) async {
    try {
      final Uri uri = setUri("/create");

      return await postRequest(uri: uri, body: reportData, useToken: true);
    } catch (e) {
      rethrow;
    }
  }
}
