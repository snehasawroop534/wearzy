import 'dart:convert';

import 'package:http/http.dart' as http;
class AuthApi {
  static Future<Map<String, dynamic>?> login(Map<String, dynamic> data)async{

    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://api-music-3fw1.onrender.com/api/project/login'));
    request.body = json.encode(data);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var body = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(body);

      return jsonResponse;
    }
    else {
      print(null);
    }

  }

  static Future<Map<String, dynamic>?> register(Map<String, dynamic> data)async{

    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://api-music-3fw1.onrender.com/api/project/register'));
    request.body = json.encode(data);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      var body = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(body);

      return jsonResponse;
    }
    return null;

  }
}