import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class GropuAPI extends APIBase {
  GropuAPI() : super(EndPoint.group);

  Future<ResponseAPI> createGroup(Map<String, dynamic> group) async {
    try {
      final Uri uri = setUri("$endpoint/");
      return await postRequest(uri: uri, body: group);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> findByUserId(String userId) async {
    try {
      final Uri uri = setUri("$endpoint/$userId");
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> deleteById(String groupId) async {
    try {
      final currentUser = AuthService.to.currentUser.value!;
      final Uri uri = setUri("$endpoint/$groupId/${currentUser.id}");
      return await deleteRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
