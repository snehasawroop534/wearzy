import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_product_model.dart';

class SearchProductService {
  static const String baseUrl =
      "https://wearzy.edugaondev.com/api/products/search/st";

  static Future<List<SearchProductModel>> searchProducts(
      String query) async {
    final url = Uri.parse("$baseUrl?q=$query");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List list = decoded["data"];

        return list
            .map((e) => SearchProductModel.fromJson(e))
            .toList();
      } else {
        throw Exception("Failed to search products");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
