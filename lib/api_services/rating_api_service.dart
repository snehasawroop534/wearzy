import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rating_model.dart';

class RatingApiService {
  static const String baseUrl = "https://wearzy.edugaondev.com/api";

  /// 🔥 ADD RATING (POST)
  static Future<bool> addRating(RatingModel rating) async {
    final response = await http.post(
      Uri.parse("$baseUrl/rating/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(rating.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// 🔥 GET RATING (orderId + productId)
  static Future<RatingModel?> getRating(
      int orderId, int productId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/rating/$orderId/$productId"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        return RatingModel.fromJson(data.first);
      }
    }
    return null;
  }
}
