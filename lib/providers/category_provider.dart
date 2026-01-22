import 'package:flutter/material.dart';
import '../api_services/category_api_service.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class CategoryProvider extends ChangeNotifier {
  // ================= CATEGORIES =================
  List<CategoryModel> _categories = [];
  bool isCategoryLoading = false;

  List<CategoryModel> get categories => _categories;

  Future<void> fetchCategories() async {
    isCategoryLoading = true;
    notifyListeners();

    try {
      _categories = await CategoryApiService.getCategories();
    } catch (e) {
      debugPrint("Category Error: $e");
    }

    isCategoryLoading = false;
    notifyListeners();
  }

  // ================= PRODUCTS BY CATEGORY =================
  List<ProductModel> _products = [];
  bool isProductsLoading = false;

  List<ProductModel> get products => _products;

  Future<void> fetchProductsByCategory(int categoryId) async {
    isProductsLoading = true;
    notifyListeners();

    try {
      _products =
      await CategoryApiService.getProductsByCategory(categoryId);
    } catch (e) {
      debugPrint("Products Error: $e");
    }

    isProductsLoading = false;
    notifyListeners();
  }

  // ================= OPTIONAL RESET =================
  void clearProducts() {
    _products = [];
    notifyListeners();
  }
}
