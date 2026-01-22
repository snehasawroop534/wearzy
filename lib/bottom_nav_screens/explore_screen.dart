import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearzy/details_screen/favourite_screen.dart';

import '../details_screen/cart_screen.dart';
import '../details_screen/product_screen.dart';
import '../details_screen/single_product_screen.dart';
import '../providers/get_cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/wishlist_provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final CarouselController _carouselController = CarouselController();
  int currentIndex = 0;

  final List<Map<String, String>> imageList = [
    {"id": "1", "image_path": "images/crausel1.jpeg"},
    {"id": "2", "image_path": "images/crausel2.jpeg"},
    {"id": "3", "image_path": "images/crausel3.jpeg"},
  ];

  @override
  Widget build(BuildContext context) {
    final accent = Colors.teal.shade300;
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0F), // near black
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 0,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteScreen(),));
                },
                child: const Icon(Icons.favorite_border, color: Colors.white)),
          ),
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

        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric( vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Top Trending",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),),
              ),
              // ------------ HOME SCREEN STYLE CAROUSEL ---------------
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductScreen()));
                    },
                    child: CarouselSlider(
                      items: imageList
                          .map(
                            (item) => Image.asset(
                          item["image_path"]!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        ),
                      )
                          .toList(),
                      carouselController: CarouselSliderController(),
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        height: 250,
                        aspectRatio: 2,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Brand Advertisement",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                  child: Image.asset("images/banw.jpeg")),

              SizedBox(height: 8,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("All Products",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),),
              ),

              Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  if (provider.productList.isEmpty) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    itemCount: provider.productList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      var product = provider.productList[index];

                      final mrp = product.mrp ?? 0;
                      final price = product.discountedPrice ?? 0;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleProductScreen(product: product),
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

                              // ⭐ IMAGE + HEART BUTTON
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
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
                                          child: const Icon(Icons.image, size: 50, color: Colors.white),
                                        );
                                      },
                                    ),
                                  ),

                                  // ❤️ Favourite Icon (TOP RIGHT)
                                  // ❤️ Favourite Icon (TOP RIGHT)
                                  // ❤️ Favourite Icon (TOP RIGHT)
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


                                ],
                              ),

                              // ⭐ TEXT AREA
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),

                                      const SizedBox(height: 3),

                                      Text(
                                        product.brand ?? "",
                                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                                      ),

                                      const SizedBox(height: 3),

                                      Text(
                                        product.description ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            "₹$price",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "₹$mrp",
                                            style: const TextStyle(
                                              color: Colors.white38,
                                              fontSize: 12,
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 4),
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

             ]
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String followText;
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.followText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?auto=format&fit=crop&w=200&q=80",
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: Colors.white70)),
              ],
            ),
          ],
        ),
        Text(followText, style: const TextStyle(color: Colors.redAccent)),
      ],
    );
  }
}

class _HorizontalBrandThumbnails extends StatelessWidget {
  final List<String> images;
  const _HorizontalBrandThumbnails({required this.images});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: images
          .map(
            (img) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            height: 110,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(img, fit: BoxFit.cover),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}

class _BrandCard extends StatelessWidget {
  final String brand;
  final String tag;
  final String imageUrl;
  const _BrandCard({
    required this.brand,
    required this.tag,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, height: 140, width: 150, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(brand, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(tag, style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ThumbCard extends StatelessWidget {
  final String label;
  final String imageUrl;
  const _ThumbCard({required this.label, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, height: 80, width: 160, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _TallCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  const _TallCard({required this.title, required this.subtitle, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, height: 180, width: 180, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold));
  }
}

class _CategoryTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  const _CategoryTile({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF101011),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Image.network(imageUrl, width: 110, height: 90, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
