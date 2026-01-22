import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';

class OrderApiService {
  static const String baseUrl = "https://wearzy.edugaondev.com/api";

  static Future<PlaceOrderResponse> placeOrder(
      PlaceOrderRequest orderRequest) async {
    final response = await http.post(
      Uri.parse("$baseUrl/order/place"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(orderRequest.toJson()),
    );

    if (response.statusCode == 200) {
      return PlaceOrderResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to place order");
    }
  }


  /// 🔥 GET MY ORDERS API
  static Future<List<MyOrderModel>> getMyOrders(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/order/my-orders?userId=$userId"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List orders = decoded["orders"];

      return orders
          .map((e) => MyOrderModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to fetch orders");
    }
  }

}
