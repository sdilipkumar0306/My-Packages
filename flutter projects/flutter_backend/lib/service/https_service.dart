import 'dart:convert';
import 'http_service_modal.dart';
import 'package:http/http.dart' as http;
// import 'dart:io' as io;

class HTTPservice {
  var response;
  static const String devUrl = "http://192.168.59.33:3000/";

  static Future<HTTPServiceModal> postCallWithAuth(path, reqBody) async {
    Uri finalUrl = Uri.parse(devUrl + path);
    try {
      var headers = {"Accept": "application/json"};
      var response = await http.post(finalUrl, headers: headers, body: reqBody);
      var responsBody = json.decode(response.body);
      if (responsBody["code"] == 200) {
        return HTTPServiceModal.fromJson(jsonDecode(response.body));
      } else {
        var error = {"code": 201, "msg": "unknown weeoe"};
        return HTTPServiceModal.fromJson((error));
      }
    } catch (e) {
      var error = {"code": 201, "msg": "Errorrrr"};
      return HTTPServiceModal.fromJson((error));
    }
  }
}
