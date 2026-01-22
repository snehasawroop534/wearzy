import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cart_model.dart';

class CartService {
  static const String baseUrl = "https://wearzy.edugaondev.com/api/cart";

  // ADD TO CART
  static Future<bool> addToCart(CartModel model) async {
    final url = "$baseUrl/add";

    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    return response.statusCode == 201;
  }

}
