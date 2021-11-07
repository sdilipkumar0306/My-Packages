import 'dart:convert';

import 'http_service_modal.dart';
import 'package:http/http.dart' as http;

class HTTPservice {
  static UserDetails? userDetails;

  var response;
  // static const String devUrl = "http://192.168.59.33:3000/";
  static const String devUrl = "http://127.0.0.1:3000/";

  static Future<HTTPServiceModal> postCallWithAuth(path, reqBody) async {
    Uri finalUrl = Uri.parse(devUrl + path);
    try {
      var headers = {"Accept": "application/json"};
      var response = await http.post(finalUrl, headers: headers, body: reqBody);
      var responsBody = json.decode(response.body);
      if (responsBody["code"] == 200) {
        return HTTPServiceModal.fromJson(jsonDecode(response.body));
      } else {
        var error = {"code": 201, "msg": "No Data Found"};
        return HTTPServiceModal.fromJson((error));
      }
    } catch (e) {
      print(e);
      var error = {"code": 201, "msg": "Errorrrr"};
      return HTTPServiceModal.fromJson((error));
    }
  }

  static Future<HTTPServiceModal> upload(imageFile, path, String fileName) async {
    String responseIMGurl = "";
    var stream = new http.ByteStream.fromBytes(imageFile);
    var uploadURL = "https://api.imgbb.com/1/upload?key=3a64367ce812f82ed3b20d872384bf93";
    var uri = Uri.parse(uploadURL);
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('image', stream, 1, filename: fileName.split(".")[0]);
    request.files.add(multipartFile);
    var response = await request.send();
    await response.stream.transform(utf8.decoder).listen((value) {
      responseIMGurl = (json.decode(value)["data"]["url"]);
    });
    if (responseIMGurl == "") {
      return HTTPServiceModal.fromJson({"code": response.statusCode, "msg": responseIMGurl});
    } else {
      return HTTPServiceModal.fromJson({"code": response.statusCode, "msg": responseIMGurl});
    }
  }
}
