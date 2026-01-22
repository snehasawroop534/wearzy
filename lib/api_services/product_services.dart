import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';


class ProductService {

  static Future<List<ProductModel>?> getProductApiData() async {
    var url = "https://wearzy.edugaondev.com/api/products";

    // 🔥 Correct image base URL
    var baseImageUrl = "https://wearzy.edugaondev.com/productImages/";

    var response = await http.get(Uri.parse(url));

    print("STATUS CODE = ${response.statusCode}");
    print("RAW RESPONSE = ${response.body}");

    if (response.statusCode == 200) {

      List<dynamic> jsonList = jsonDecode(response.body);

      // Modify image field → full URL
      jsonList = jsonList.map((item) {
        if (item["image"] != null && item["image"] != "") {
          item["image"] = baseImageUrl + item["image"];
        }
        return item;
      }).toList();

      // Debug Print
      for (var item in jsonList) {
        print("FINAL IMAGE URL = ${item["image"]}");
      }

      return jsonList.map((e) => ProductModel.jsonToModel(e)).toList();
    }

    return null;
  }
}
