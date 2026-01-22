import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearzy/details_screen/cart_screen.dart';
import 'package:wearzy/details_screen/single_product_screen.dart';
import 'package:wearzy/details_screen/favourite_screen.dart';
import 'package:wearzy/providers/category_provider.dart';
import '../providers/get_cart_provider.dart';
import '../providers/wishlist_provider.dart';

class CategoryProductScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {

  @override
  void initState() {
    super.initState();
    loadWishlist();

    // Fetch products for the selected category
    Future.microtask(() {
      Provider.of<CategoryProvider>(context, listen: false)
          .fetchProductsByCategory(widget.categoryId);
    });
  }

  Future<void> loadWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    if (userId != null) {
      Future.microtask(() {
        Provider.of<WishlistProvider>(context, listen: false)
            .fetchWishlist(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back,color: Colors.white,)),
        title: Text(widget.categoryName,style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border,color: Colors.white,),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FavouriteScreen()));
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined,color: Colors.white,),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CartScreen()));
                },
              ),
              Positioned(
                right: 6,
                top: 6,
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
                            color: Colors.white, fontSize: 10),
                      ),
                    )
                        : const SizedBox();
                  },
                ),
              )
            ],
          )
        ],
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          final products = categoryProvider.products;


          if (categoryProvider.isCategoryLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (products.isEmpty) {
            return const Center(
              child: Text("No Products Found", style: TextStyle(color: Colors.white)),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              final mrp = product.mrp ?? 0;
              final price = product.discountedPrice ?? 0;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SingleProductScreen(product: product)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                            child: Image.network(
                              product.image.toString(),
                              height: 177,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 177,
                                  width: double.infinity,
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
                            child: Consumer<WishlistProvider>(
                              builder: (context, wishlistProvider, child) {
                                bool isLiked =
                                wishlistProvider.isLiked(product.productId ?? 0);

                                return LikeButton(
                                  size: 20,
                                  isLiked: isLiked,
                                  likeBuilder: (liked) => Icon(
                                    liked
                                        ? CupertinoIcons.heart_fill
                                        : CupertinoIcons.heart,
                                    color: liked ? Colors.pink : Colors.grey,
                                    size: 20,
                                  ),
                                  onTap: (liked) async {
                                    SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                    int? userId = prefs.getInt("user_id");

                                    if (userId == null) return liked;

                                    bool newState = await wishlistProvider
                                        .toggleWishlist(
                                        userId, product.productId ?? 0);
                                    return newState;
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.title ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 3),
                              Text(product.brand ?? "",
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 12)),
                              const SizedBox(height: 3),
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
                                          decoration: TextDecoration.lineThrough)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
