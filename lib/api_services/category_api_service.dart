import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/product_model.dart';

class CategoryApiService {
  static const String baseUrl = "https://wearzy.edugaondev.com/api";

  // 🔥 SAME image base URL
  static const String baseImageUrl =
      "https://wearzy.edugaondev.com/productImages/";

  /// GET all categories
  static Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(Uri.parse("$baseUrl/categories"));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }

  /// ✅ GET products by category id (IMAGE URL FIXED)
  static Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/categories/$categoryId/products"),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      // 🔥 image filename → full URL
      data = data.map((item) {
        if (item["image"] != null && item["image"] != "") {
          item["image"] = baseImageUrl + item["image"];
        }
        return item;
      }).toList();

      // optional debug
      for (var item in data) {
        print("CATEGORY IMAGE URL = ${item["image"]}");
      }

      return data
          .map((e) => ProductModel.jsonToModel(e))
          .toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
