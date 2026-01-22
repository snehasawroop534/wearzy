import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/wishlist_item_model.dart';

class WishlistApiService {
  final String baseUrl = "https://wearzy.edugaondev.com/api";

  // -----------------------------
  // 🔵 GET WISHLIST (FULL DATA)
  // -----------------------------
  Future<List<WishlistItem>> getWishlist(int userId) async {
    final response =
    await http.get(Uri.parse("$baseUrl/wishlist/$userId"));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List list = jsonData["data"];

      return list
          .map((e) => WishlistItem.fromGetJson(e))
          .toList();
    } else {
      throw Exception("Failed to load wishlist");
    }
  }

  // -----------------------------
  // 🔵 ADD TO WISHLIST
  // -----------------------------
  Future<WishlistItem?> addToWishlist(
      int userId, int productId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/wishlist/add"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "productId": productId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return WishlistItem.fromAddJson(jsonData);
      }
      return null;
    } catch (e) {
      debugPrint("Add wishlist error: $e");
      return null;
    }
  }

  // -----------------------------
  // 🔴 DELETE WISHLIST
  // -----------------------------
  Future<bool> removeWishlist(int wishlistId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/wishlist/$wishlistId"),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Remove wishlist error: $e");
      return false;
    }
  }
}
