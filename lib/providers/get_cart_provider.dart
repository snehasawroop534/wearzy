import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_services/get_cart_service.dart';
import '../models/cart_model.dart';
import '../api_services/cart_service.dart';
import '../models/get_cart_model.dart';

class GetCartProvider with ChangeNotifier {
  List<GetCartModel> cartList = [];

  Future<void> fetchCart(int userId) async {
    var carts = await GetCartService.getCart(userId);
    if (carts != null) {
      cartList.clear();
      cartList.addAll(carts);
      notifyListeners();
    }
  }

  double totalAmount(Map<int, int> quantityMap) {
    double total = 0;

    for (var item in cartList) {
      final cartId = item.cartId ?? 0;
      final qty = quantityMap[cartId] ?? 1;
      final price =
          double.tryParse(item.product?.discountedPrice ?? "0") ?? 0;

      total += price * qty;
    }

    return total;
  }


  Future<bool> removeItem(int cartId) async {
    bool success = await GetCartService.deleteCart(cartId);

    if (success) {
      cartList.removeWhere((item) => item.cartId == cartId);
      notifyListeners();
    }

    return success;
  }

}
