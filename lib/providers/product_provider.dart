import 'package:flutter/material.dart';

import '../api_services/product_services.dart';
import '../models/product_model.dart';
import '../models/search_product_model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> productList = [];
  bool isLoading = false; // ⭐ ADD THIS

  getProduct() async {
    isLoading = true;
    notifyListeners();

    var products = await ProductService.getProductApiData();

    if (products != null) {
      productList.clear();
      productList.addAll(products);
    }

    isLoading = false;
    notifyListeners();
  }
}


