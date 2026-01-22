import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileApi {

  // -------------------------------------------------
  // GET PROFILE API (Already Given)
  // -------------------------------------------------
  static Future<Map<String, dynamic>?> userProfile() async {
    var prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    if (token == null) return null;

    var headers = {
      "Content-Type": "application/json",
      "Authorization": token,
    };

    var response = await http.get(
      Uri.parse('https://wearzy.edugaondev.com/api/user/profile'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.body);
      return null;
    }
  }

  // -------------------------------------------------
  // UPDATE PROFILE API (ADDED NOW)  ✅🔥
  // -------------------------------------------------
  static Future<bool> updateProfileApi({
    required String name,
    required String email,
    required int userId,
  }) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");

      if (token == null) return false;

      final url = Uri.parse(
        "https://wearzy.edugaondev.com/api/user/profile/update/$userId",
      );

      var response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: jsonEncode({
          "name": name,
          "email": email,
        }),
      );

      if (response.statusCode == 200) {
        print("Profile Updated Successfully");
        return true;
      } else {
        print("Update Failed: ${response.body}");
        return false;
      }

    } catch (e) {
      print("Update Profile API Error: $e");
      return false;
    }
  }
}
