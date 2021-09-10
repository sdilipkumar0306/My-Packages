import 'dart:convert';
// import 'dart:html';
// import 'dart:html' as html;

import 'http_service_modal.dart';
import 'package:http/http.dart' as http;

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
// import 'dart:io' as io;
// import 'package:http/http.dart' as http;

// import 'dart:io' as io;

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

  static Future<dynamic> upload(imageFile, path) async {
    print("aaaaaaaaaa--------- $path");

    // var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var stream = new http.ByteStream.fromBytes(imageFile);
    print("bbbbbbbbbbb--------- $stream");
    var uploadURL = "https://api.imgbb.com/1/upload?expiration=600&key=3a64367ce812f82ed3b20d872384bf93";
    var uri = Uri.parse(uploadURL);
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('image', stream, 1, filename: basename(path));
    print(multipartFile.filename);
    print(multipartFile.field);
    print(multipartFile. contentType);
    //contentType: new MediaType('image', 'png'));
    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value.splitMapJoin(":"));
      // print(jsonEncode(value)[0]);
    });
    return response;
  }
}
