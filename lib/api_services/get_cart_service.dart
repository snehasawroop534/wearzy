import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cart_model.dart';
import '../models/get_cart_model.dart';

class GetCartService {
  static var baseUrl = "https://wearzy.edugaondev.com";

  static Future<List<GetCartModel>?> getCart(int userId) async {
    var url = "$baseUrl/api/get/cart/$userId";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => GetCartModel.jsonToModel(e)).toList();
      } else {
        print("Failed to fetch cart. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching cart: $e");
    }

    return null;
  }


  static Future<bool> deleteCart(int cartId) async {
    try {
      final response = await http.delete(
        Uri.parse("https://wearzy.edugaondev.com/api/cart/$cartId"),
      );

      if (response.statusCode == 200) {
        return true; // deleted successfully
      }
      return false; // failed
    } catch (e) {
      return false;
    }
  }
}
