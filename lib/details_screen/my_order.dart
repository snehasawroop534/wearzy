import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearzy/details_screen/order_details.dart';

import '../models/rating_model.dart';
import '../providers/order_provider.dart';
import '../providers/rating_provider.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  /// ⭐ TEMP STAR SELECTION
  final Map<String, int> _tempRatings = {};
  String _key(int orderId, int productId) => "$orderId-$productId";

  /// 🔍 SEARCH
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final userId = await _getUserId();
      if (userId != null) {
        Provider.of<OrderProvider>(context, listen: false)
            .fetchMyOrders(userId);
      }
    });

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }


  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "My Orders",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          /// 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search your order here",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.filter_alt_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          /// 📦 ORDER LIST
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(child: Text(provider.errorMessage!));
                }

                if (provider.myOrders.isEmpty) {
                  return const Center(child: Text("No orders found"));
                }

                /// 🔥 SORT
                final orders = [...provider.myOrders];
                orders.sort((a, b) =>
                    b.createdAt.compareTo(a.createdAt));

                /// 🔍 FILTER BY PRODUCT NAME
                final filteredOrders = orders.where((order) {
                  return order.items.any((item) =>
                      item.title.toLowerCase().contains(_searchQuery));
                }).toList();

                if (filteredOrders.isEmpty) {
                  return const Center(
                      child: Text("No matching products found"));
                }

                return ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    final firstItem = order.items.first;

                    Provider.of<RatingProvider>(context, listen: false)
                        .fetchRating(order.orderId, firstItem.productId);

                    final apiRating = context
                        .watch<RatingProvider>()
                        .getRatingData(
                        order.orderId, firstItem.productId)
                        ?.rating ??
                        0;

                    final key =
                    _key(order.orderId, firstItem.productId);

                    final currentRating =
                        _tempRatings[key] ?? apiRating;

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                OrderDetails(order: order),
                          ),
                        );
                      },
                      child: orderTile(
                        orderId: order.orderId,
                        productId: firstItem.productId,
                        currentRating: currentRating,
                        img: firstItem.image,
                        date:
                        "Order on ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}",
                        title: firstItem.title,
                        description: firstItem.description,
                        onStarTap: (value) {
                          setState(() {
                            _tempRatings[key] = value;
                          });

                          _showRatingBottomSheet(
                            context,
                            order.orderId,
                            firstItem.productId,
                            value,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  /// 🧱 ORDER TILE
  Widget orderTile({
    required int orderId,
    required int productId,
    required int currentRating,
    required String img,
    required String date,
    required String title,
    required String description,
    required Function(int) onStarTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "https://wearzy.edugaondev.com/productImages/${img}",
              height: 70,
              width: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 70,
                width: 70,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                  const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),

                /// ⭐ STAR
                Row(
                  children: List.generate(
                    5,
                        (index) => GestureDetector(
                      onTap: () => onStarTap(index + 1),
                      child: Icon(
                        index < currentRating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                currentRating > 0
                    ? const Text(
                  "Write a Review",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight:
                      FontWeight.w500),
                )
                    : const Text(
                  "Rate this product now",
                  style:
                  TextStyle(color: Colors.grey),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 📝 RATING BOTTOM SHEET
  void _showRatingBottomSheet(
      BuildContext context,
      int orderId,
      int productId,
      int rating) {
    final reviewController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
            MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                "Write a Review",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText:
                  "Write your experience...",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Consumer<RatingProvider>(
                builder: (_, provider, __) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                        final userId = await _getUserId();
                        if (userId == null) return;

                        final ratingModel = RatingModel(
                          userId: userId,
                          orderId: orderId,
                          productId: productId,
                          rating: rating,
                          review: reviewController.text,
                        );

                        final success =
                        await provider.addRating(ratingModel);

                        if (success) {
                          setState(() {
                            _tempRatings.remove(
                                _key(orderId, productId));
                          });
                          Navigator.pop(context);
                        }
                      },

                      child: provider.isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text("Submit Review"),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
