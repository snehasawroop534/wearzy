import 'package:flutter/material.dart';
import 'package:wearzy/models/wishlist_item_model.dart';
import '../api_services/wishlist_api_service.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistApiService _service = WishlistApiService();

  // 🔥 SERVER WISHLIST
  List<WishlistItem> wishlist = [];
  bool loading = false;

  // -----------------------------
  // 🔵 FETCH WISHLIST
  // -----------------------------
  Future<void> fetchWishlist(int userId) async {
    try {
      loading = true;
      notifyListeners();

      wishlist = await _service.getWishlist(userId);
    } catch (e) {
      debugPrint("Fetch wishlist error: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // -----------------------------
  // 🔵 ADD TO WISHLIST (NO DUPLICATE)
  // -----------------------------
  Future<bool> addWishlist(int userId, int productId) async {
    bool alreadyLiked =
    wishlist.any((item) => item.productId == productId);

    if (alreadyLiked) {
      return false;
    }

    final result = await _service.addToWishlist(userId, productId);

    if (result != null) {
      await fetchWishlist(userId);
      return true;
    }
    return false;
  }

  // -----------------------------
  // ❤️ TOGGLE WISHLIST (ADD / REMOVE)
  // -----------------------------
  Future<bool> toggleWishlist(int userId, int productId) async {
    WishlistItem? existingItem;

    try {
      existingItem = wishlist.firstWhere(
            (item) => item.productId == productId,
      );
    } catch (e) {
      existingItem = null;
    }

    // 🔴 REMOVE
    if (existingItem != null) {
      bool success = await _service.removeWishlist(existingItem.id);
      if (success) {
        wishlist.removeWhere((item) => item.id == existingItem?.id);
        notifyListeners();
        return false; // now unliked
      }
      return true;
    }

    // 🟢 ADD
    final result = await _service.addToWishlist(userId, productId);
    if (result != null) {
      await fetchWishlist(userId);
      return true; // now liked
    }

    return false;
  }

  // -----------------------------
  // 🔴 DELETE WISHLIST ITEM
  // -----------------------------
  Future<bool> deleteWishlistItem(int userId, int wishlistId) async {
    bool success = await _service.removeWishlist(wishlistId);

    if (success) {
      await fetchWishlist(userId);
    }
    return success;
  }

  // -----------------------------
  // ❤️ CHECK LIKE STATUS
  // -----------------------------
  bool isLiked(int productId) {
    return wishlist.any((item) => item.productId == productId);
  }

  // -----------------------------
  // 🔴 LOCAL REMOVE
  // -----------------------------
  void removeLocal(int wishlistId) {
    wishlist.removeWhere((item) => item.id == wishlistId);
    notifyListeners();
  }
}
