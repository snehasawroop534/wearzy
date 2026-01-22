import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearzy/details_screen/single_product_screen.dart';

import '../models/product_model.dart';
import '../providers/get_cart_provider.dart';
import '../providers/search_product_provider.dart';
import '../providers/wishlist_provider.dart';
import 'cart_screen.dart';
import 'favourite_screen.dart';

class SearchProductDetails extends StatefulWidget {

  final int? productId;

  const SearchProductDetails({super.key,  this.productId});

  @override
  State<SearchProductDetails> createState() => _SearchProductDetailsState();
}

class _SearchProductDetailsState extends State<SearchProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back,color: Colors.white,)),
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 8, left: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search by product, brand...',
              hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.black54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => FavouriteScreen()));
              },
              child: const Icon(Icons.favorite_border, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => CartScreen()));
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_bag_outlined,
                      color: Colors.white, size: 28),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Consumer<GetCartProvider>(
                      builder: (context, cartProv, _) {
                        return cartProv.cartList.isNotEmpty
                            ? Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cartProv.cartList.length.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                            : const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ================= BODY =================
      body: ListView(
        children: [
          Consumer<SearchProductProvider>(
            builder: (context, provider, child) {
              if (provider.searchList.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "No Products Found",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: provider.searchList.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final item = provider.searchList[index];

                  final mrp = double.tryParse(item.mrp) ?? 0;
                  final price =
                      double.tryParse(item.discountedPrice) ?? 0;

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      final product = ProductModel(
                        null, // id
                        item.productId, // productId
                        item.productId, // categoryId (agar search model me hai)
                        item.title ?? "",
                        item.brand ?? "",
                        item.mrp.toString(),
                        item.discountedPrice.toString(),
                        item.description ?? "",
                        "https://wearzy.edugaondev.com/productImages/${item.image}",
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SingleProductScreen(product: product),
                        ),
                      );
                    },


                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ========== IMAGE + WISHLIST ==========
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Image.network(
                                  "https://wearzy.edugaondev.com/productImages/${item.image}",
                                  height: 177,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return Container(
                                      height: 177,
                                      width: 177,
                                      color: Colors.grey.shade700,
                                      child: const Icon(Icons.image,
                                          size: 50, color: Colors.white),
                                    );
                                  },
                                ),
                              ),

                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: Consumer<WishlistProvider>(
                                    builder: (context, wishlistProvider, _) {
                                      bool isLiked = wishlistProvider.wishlist.any(
                                              (w) =>
                                          w.productId == item.productId);

                                      return LikeButton(
                                        size: 20,
                                        isLiked: isLiked,
                                        likeBuilder: (liked) {
                                          return Icon(
                                            liked
                                                ? CupertinoIcons.heart_fill
                                                : CupertinoIcons.heart,
                                            color:
                                            liked ? Colors.pink : Colors.grey,
                                            size: 20,
                                          );
                                        },
                                        onTap: (liked) async {
                                          SharedPreferences prefs =
                                          await SharedPreferences
                                              .getInstance();
                                          int? userId =
                                          prefs.getInt("user_id");

                                          if (userId == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please login first")));
                                            return false;
                                          }

                                          return await wishlistProvider
                                              .addWishlist(
                                              userId, item.productId);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // ========== TEXT ==========
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 3),
                                  Text(item.brand,
                                      style: const TextStyle(
                                          color: Colors.white54, fontSize: 12)),
                                  const SizedBox(height: 3),
                                  Text(item.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white54, fontSize: 12)),
                                  Row(
                                    children: [
                                      Text("₹$price",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 4),
                                      Text("₹$mrp",
                                          style: const TextStyle(
                                              color: Colors.white38,
                                              decoration:
                                              TextDecoration.lineThrough)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),

      // ================= BOTTOM NAV (UNCHANGED) =================
      bottomNavigationBar: Container(
        color: const Color(0xFF121212),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: const [
              Icon(Icons.sort, color: Colors.white70),
              SizedBox(width: 5),
              Text("SORT BY", style: TextStyle(color: Colors.white)),
            ]),
            Row(children: const [
              Icon(Icons.category, color: Colors.white70),
              SizedBox(width: 5),
              Text("CATEGORY", style: TextStyle(color: Colors.white)),
            ]),
            Row(children: const [
              Icon(Icons.filter_list, color: Colors.white70),
              SizedBox(width: 5),
              Text("FILTERS", style: TextStyle(color: Colors.white)),
            ]),
          ],
        ),
      ),
    );
  }
}
