import 'package:flutter/material.dart';
import '../api_services/order_api_service.dart';
import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  int? orderId;

  /// 🔥 MY ORDERS LIST
  List<MyOrderModel> myOrders = [];

  /// 🔥 PLACE ORDER (UNCHANGED)
  Future<void> placeOrder({
    required int userId,
    required double totalAmount,
    required List<OrderItem> items,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final request = PlaceOrderRequest(
        userId: userId,
        totalAmount: totalAmount,
        items: items,
      );

      final response =
      await OrderApiService.placeOrder(request);

      orderId = response.orderId;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔥 GET MY ORDERS
  Future<void> fetchMyOrders(int userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      myOrders = await OrderApiService.getMyOrders(userId);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
