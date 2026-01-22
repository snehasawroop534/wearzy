import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearzy/details_screen/cart_screen.dart';
import 'package:wearzy/details_screen/product_screen.dart';
import 'package:wearzy/details_screen/single_product_screen.dart';
import '../models/product_model.dart';
import '../providers/get_cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_model.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {

  @override
  void initState() {
    super.initState();
    loadUserWishlist();
  }

  Future<void> loadUserWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    Provider.of<WishlistProvider>(context, listen: false)
        .fetchWishlist(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
        ),
        title: const Text(
          "Wishlist",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartScreen()));
                  },
                  child: const Icon(Icons.shopping_bag_outlined,
                      color: Colors.black, size: 32),
                ),
              ),
              Positioned(
                right: 17,
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
          )
        ],
      ),

      body: Consumer<WishlistProvider>(
        builder: (context, provider, child) {

          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.wishlist.isEmpty) {
            return const Center(
              child: Text(
                "No items in wishlist",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),

              itemCount: provider.wishlist.length,
              itemBuilder: (context, index) {
                final item = provider.wishlist[index];

                final mrp = double.tryParse(item.mrp ?? "0") ?? 0;
                final discounted =
                    double.tryParse(item.discountedPrice ?? "0") ?? 0;

                final discountPercent = mrp > 0
                    ? ((1 - (discounted / mrp)) * 100).toInt()
                    : 0;

                return buildProductCard(
                  itemId: item.id,
                  productId: item.productId ?? 0,
                  image:
                  "https://wearzy.edugaondev.com/productImages/${item.image ?? ""}",
                  brand: item.brand ?? "",
                  title: item.title ?? "",
                  price: "₹${item.discountedPrice ?? "0"}",
                  oldPrice: "₹${item.mrp ?? "0"}",
                  discount: "$discountPercent% off",
                  discountedPrice: item.discountedPrice ?? "0",
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildProductCard({
    required int itemId,
    required int productId,
    required String image,
    required String brand,
    required String title,
    required String price,
    required String oldPrice,
    required String discount,
    required String discountedPrice,
  }) {
    return Builder(
        builder: (ctx) => GestureDetector(
          onTap: () {
            final product = ProductModel(
              null,                // id
              productId,           // productId
              null,                // categoryId
              title,
              brand,
              oldPrice.replaceAll("₹", ""),
              discountedPrice,
              "",                  // description (wishlist me nahi hota)
              image,
            );

            Navigator.of(ctx).push(
              MaterialPageRoute(
                builder: (_) => SingleProductScreen(
                  product: product,
                ),
              ),
            );
          },

          child: Container(

          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              brand,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
              height: 36,
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  oldPrice,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  discount,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [

                /// ❤️ DELETE WISHLIST
                GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    int? userId = prefs.getInt("user_id");

                    if (userId == null) return;

                    final provider =
                    Provider.of<WishlistProvider>(context, listen: false);

                    bool success =
                    await provider.deleteWishlistItem(userId, itemId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? "Removed from wishlist"
                              : "Failed to remove item",
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Icon(Icons.delete_outline, size: 22),
                  ),
                ),

                const SizedBox(width: 8),

                /// 🛒 ADD TO BAG — SAME LOGIC AS SINGLE PRODUCT
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      int? userId = prefs.getInt("user_id");

                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please login first")),
                        );
                        return;
                      }

                      final cartProvider =
                      Provider.of<CartProvider>(context, listen: false);

                      int price =
                          int.tryParse(discountedPrice) ?? 0;

                      CartModel cartData = CartModel(
                        userId: userId,
                        productId: productId,
                        size: "4XL",
                        quantity: 1,
                        price: price.toString(),
                      );

                      bool ok = await cartProvider.addToCart(cartData);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok ? "Added to bag!" : "Failed to add item",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Add to Bag",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
        )
    );
  }
}
