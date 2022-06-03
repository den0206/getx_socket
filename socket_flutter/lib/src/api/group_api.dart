import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/response_api.dart';

class GropuAPI extends APIBase {
  GropuAPI() : super(EndPoint.group);

  Future<ResponseAPI> createGroup(Map<String, dynamic> group) async {
    try {
      final Uri uri = setUri("/");
      return await postRequest(uri: uri, body: group, useToken: true);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseAPI> findByUserId(String userId) async {
    try {
      final Uri uri = setUri("/userId");
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseAPI> deleteById(String groupId) async {
    try {
      final Map<String, dynamic> q = {"groupId": groupId};

      final Uri uri = setUri("/delete", q);
      return await deleteRequest(uri: uri, useToken: true);
    } catch (e) {
      throw e;
    }
  }
}
