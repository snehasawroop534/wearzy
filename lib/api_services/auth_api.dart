import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {

  // ---------------- LOGIN ----------------
  static Future<Map<String, dynamic>?> login(Map<String, dynamic> data) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse('https://wearzy.edugaondev.com/api/user/login')
    );

    request.body = json.encode(data);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var body = await response.stream.bytesToString();
      return jsonDecode(body);
    }
    return null;
  }

  // ---------------- REGISTER ----------------
  static Future<Map<String, dynamic>?> register(Map<String, dynamic> data) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse('https://wearzy.edugaondev.com/api/user/register')
    );

    request.body = json.encode(data);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      var body = await response.stream.bytesToString();
      return jsonDecode(body);
    }
    return null;
  }

  // ---------------- LOGOUT ----------------
  static Future<bool> logout() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final refreshToken = pref.getString('refresh_token');

      if (refreshToken == null || refreshToken.isEmpty) {
        return true;
      }

      final url = Uri.parse('https://wearzy.edugaondev.com/api/auth/logout');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refreshToken": refreshToken}),
      );

      if (response.statusCode == 200) {
        await pref.remove('access_token');
        await pref.remove('refresh_token');
        await pref.setBool('login_status_key', false);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  // **************************************************************
  // ****************** FORGOT PASSWORD SECTION *******************
  // **************************************************************

  // ---------------- SEND OTP ----------------
  static Future<Map<String, dynamic>?> sendOtp(Map<String, dynamic> data) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse('https://wearzy.edugaondev.com/api/auth/send-otp')
      );

      request.body = json.encode(data);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var body = await response.stream.bytesToString();
        return jsonDecode(body);
      }

      return null;
    } catch (e) {
      print("Send OTP Error: $e");
      return null;
    }
  }

  // ---------------- RESET PASSWORD ----------------
  static Future<Map<String, dynamic>?> resetPassword(
      Map<String, dynamic> data) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse('https://wearzy.edugaondev.com/api/auth/reset-password')
      );

      request.body = json.encode(data);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var body = await response.stream.bytesToString();
        return jsonDecode(body);
      }

      return null;
    } catch (e) {
      print("Reset Password Error: $e");
      return null;
    }
  }
}
