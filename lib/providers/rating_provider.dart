import 'package:flutter/material.dart';
import '../api_services/rating_api_service.dart';
import '../models/rating_model.dart';


class RatingProvider extends ChangeNotifier {
  final Map<String, RatingModel?> _ratings = {};
  bool isLoading = false;

  String _key(int orderId, int productId) =>
      "$orderId-$productId";

  RatingModel? getRatingData(int orderId, int productId) {
    return _ratings[_key(orderId, productId)];
  }

  /// 🔥 GET RATING
  Future<void> fetchRating(int orderId, int productId) async {
    final key = _key(orderId, productId);

    // already fetched → API call mat karo
    if (_ratings.containsKey(key)) return;

    _ratings[key] =
    await RatingApiService.getRating(orderId, productId);

    notifyListeners();
  }

  /// 🔥 ADD RATING
  Future<bool> addRating(RatingModel rating) async {
    isLoading = true;
    notifyListeners();

    final success =
    await RatingApiService.addRating(rating);

    if (success) {
      _ratings[_key(rating.orderId, rating.productId)] =
          rating;
    }

    isLoading = false;
    notifyListeners();
    return success;
  }
}
