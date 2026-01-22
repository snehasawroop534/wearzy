import 'package:flutter/material.dart';
import '../api_services/search_product_service.dart';
import '../models/search_product_model.dart';

class SearchProductProvider extends ChangeNotifier {
  List<SearchProductModel> searchList = [];
  bool loading = false;
  String error = "";

  Future<void> searchProducts(String query) async {
    loading = true;
    error = "";
    notifyListeners();

    try {
      searchList = await SearchProductService.searchProducts(query);
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  void clearSearch() {
    searchList.clear();
    notifyListeners();
  }
}
