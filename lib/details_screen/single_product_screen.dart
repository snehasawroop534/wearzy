import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearzy/details_screen/cart_screen.dart';
import 'package:wearzy/details_screen/favourite_screen.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/get_cart_provider.dart';
import '../providers/wishlist_provider.dart';

class SingleProductScreen extends StatefulWidget {
  final ProductModel product;   // ⭐ RECEIVE PRODUCT MODEL

  const SingleProductScreen({super.key, required this.product});

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {

  String selectedColor = "Brown";
  String selectedSize = "4XL";

  @override
  Widget build(BuildContext context) {

    final product = widget.product;   // ⭐ EASY ACCESS

    return Scaffold(
      backgroundColor: Colors.black,
     // extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteScreen(),));
              },
              child: const Icon(Icons.favorite_border, color: Colors.white)),
          const SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),

                  // ⭐ CART COUNT BADGE
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Consumer<GetCartProvider>(
                      builder: (context, cartProv, child) {
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
                              fontWeight: FontWeight.bold,
                            ),
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

          const SizedBox(width: 16),
        ],
      ),


      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ⭐ PRODUCT IMAGE
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Image.network(
                product.image.toString(),
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Center(
                  child: Icon(Icons.image, color: Colors.white, size: 60),
                ),
              ),
            ),

            // ⭐ PRODUCT DETAILS
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    product.title ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    product.brand ?? "",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Text(
                        "₹${product.discountedPrice}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "₹${product.mrp}",
                        style: const TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Price inclusive of all taxes.",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  const SizedBox(height: 20),

                  // ⭐ Product Description
                  const Text(
                    "Description",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    product.description ?? "",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),

                  const SizedBox(height: 20),

                  // REST OF UI → NO CHANGE 🔥
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        color: const Color(0xFF1A1A1A),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            _bottomIcon(Icons.share_outlined),
            const SizedBox(width: 10),
            // ❤️ Bottom Left Favourite Icon Implemented
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Consumer<WishlistProvider>(
                  builder: (context, wishlistProvider, child) {

                    // ✅ CHECK LIKE STATUS
                    bool isLiked = wishlistProvider.isLiked(
                      product.productId ?? 0,
                    );

                    return LikeButton(
                      size: 20,
                      isLiked: isLiked,

                      likeBuilder: (liked) {
                        return Icon(
                          liked
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: liked ? Colors.pink : Colors.grey,
                          size: 20,
                        );
                      },

                      onTap: (liked) async {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        int? userId = prefs.getInt("user_id");

                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please login first"),
                            ),
                          );
                          return liked; // ❗ state unchanged
                        }

                        // 🔥 TOGGLE WISHLIST
                        bool newState =
                        await wishlistProvider.toggleWishlist(
                          userId,
                          product.productId ?? 0,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              newState
                                  ? "Item added to wishlist"
                                  : "Item removed from wishlist",
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        return newState; // 🔥 IMPORTANT FOR LIKE BUTTON
                      },
                    );
                  },
                ),

              ),
            ),

            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  int? userId = prefs.getInt("user_id");

                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please login first")),
                    );
                    return;
                  }

                  final cartProvider = Provider.of<CartProvider>(context, listen: false);

                  int price = int.tryParse(widget.product.discountedPrice ?? "0") ?? 0;

                  // ⭐ CREATE CART MODEL
                  CartModel cartData = CartModel(
                    userId: userId,
                    productId: widget.product.productId!,
                    size: selectedSize,
                    quantity: 1,
                    price: price.toString(),
                  );

                  // ⭐ CALL PROVIDER WITH MODEL
                  bool ok = await cartProvider.addToCart(cartData);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ok ? "Added to bag!" : "Failed to add item"),
                    ),
                  );
                },


                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCF8A7D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Add To Bag",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _bottomIcon(IconData icon) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
