import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../api_services/cart_service.dart';

class CartProvider with ChangeNotifier {
  bool isLoading = false;

  List<CartModel> cartList = [];

  // ADD TO CART
  Future<bool> addToCart(CartModel model) async {
    isLoading = true;
    notifyListeners();

    bool success = await CartService.addToCart(model);

    isLoading = false;
    notifyListeners();

    return success;
  }

}
