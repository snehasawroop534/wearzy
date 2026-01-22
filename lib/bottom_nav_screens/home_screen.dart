import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wearzy/details_screen/cart_screen.dart';
import 'package:wearzy/details_screen/search_screen.dart';
import 'package:wearzy/details_screen/single_product_screen.dart';
import 'package:wearzy/details_screen/product_screen.dart';
import 'package:wearzy/details_screen/favourite_screen.dart';

import '../providers/get_cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/wishlist_provider.dart'; // <-- ADD THIS

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });

    // ⭐ Fetch products
    Provider.of<ProductProvider>(context, listen: false).getProduct();

    // ⭐⭐⭐ FETCH WISHLIST (IMPORTANT)
    loadWishlist();
    loadCart(); // ✅ ADD THIS

  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("user_id");

    if (userId != null) {
      Future.microtask(() {
        Provider.of<GetCartProvider>(context, listen: false)
            .fetchCart(userId);
      });
    }
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


  int selectedTab = 0;


  List imageList = [
    {"id": 1, "image_path": "images/banner wear.jpg"},
    {"id": 2, "image_path": "images/banner shoes.jpg"},
    {"id": 3, "image_path": "images/banner dwn.jpg"},
  ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;



  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 0,
        title: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),));
          },
          child: Container(
              height: height * 0.05,
            margin: const EdgeInsets.only(right: 8, left: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
                child: Row(
                  spacing: 25,
              children: [
                SizedBox(width: 0.1,),
                Icon(Icons.search),
                Text('Search by product, brand...',style: TextStyle(fontSize:16,),),
              ],
            ))
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavouriteScreen()));
              },
              child:
              const Icon(Icons.favorite_border, color: Colors.white),
            ),
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

      // MAIN BODY
      body: ListView(
        children: [

          // ------------ Slider ---------------
          isLoading
              ? Padding(
            padding: const EdgeInsets.all(10),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade800,
              highlightColor: Colors.grey.shade700,
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          )
              : Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductScreen(),
                    ),
                  );
                },
                child: CarouselSlider(
                  items: imageList
                      .map(
                        (item) => Image.asset(
                      item["image_path"],
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


          // ------------ Sections ---------------
          // (same as your original code — untouched)

          // ---------------------------------------------------------
          //                ⭐ PRODUCT LIST FROM API ⭐
          // ---------------------------------------------------------

          sectionTitle("PRODUCTS"),
          Consumer<ProductProvider>(
            builder: (context, provider, child) {

              // ⭐ 1️⃣ JAB DATA LOAD HO RAHA HO → SHIMMER
              if (provider.isLoading) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade700,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 177,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(height: 14, width: 100, color: Colors.white),
                                  const SizedBox(height: 6),
                                  Container(height: 12, width: 70, color: Colors.white),
                                  const SizedBox(height: 6),
                                  Container(height: 12, width: 120, color: Colors.white),
                                  const SizedBox(height: 6),
                                  Container(height: 14, width: 60, color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              // ⭐ 2️⃣ DATA AANE KE BAAD → TUMHARA EXISTING CODE (UNCHANGED)
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
                          builder: (context) =>
                              SingleProductScreen(product: product),
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
                                      child: const Icon(Icons.image,
                                          size: 50, color: Colors.white),
                                    );
                                  },
                                ),
                              ),

                              // ❤️ Favourite Icon
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
                                            color:
                                            liked ? Colors.pink : Colors.grey,
                                            size: 20,
                                          );
                                        },
                                        onTap: (liked) async {
                                          SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                          int? userId =
                                          prefs.getInt("user_id");

                                          if (userId == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                Text("Please login first"),
                                              ),
                                            );
                                            return liked;
                                          }

                                          bool newState =
                                          await wishlistProvider
                                              .toggleWishlist(
                                            userId,
                                            product.productId ?? 0,
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                newState
                                                    ? "Item added to wishlist"
                                                    : "Item removed from wishlist",
                                              ),
                                            ),
                                          );

                                          return newState;
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
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
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
                                    style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(height: 3),
                                  // Text(
                                  //   product.description ?? "",
                                  //   maxLines: 1,
                                  //   overflow: TextOverflow.ellipsis,
                                  //   style: const TextStyle(
                                  //       color: Colors.white54,
                                  //       fontSize: 12),
                                  // ),
                                  Row(
                                    children: [
                                      Text(
                                        "₹$price",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "₹$mrp",
                                        style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 12,
                                          decoration:
                                          TextDecoration.lineThrough,
                                        ),
                                      ),
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



          const SizedBox(height: 20),
        ],
      ),
    );
  }





  Widget bannerTile(String imageUrl) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    );
  }

  Widget horizontalImageList(List<String> imageUrls) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrls[index],
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget twoImageRow(String leftImg, String rightImg) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
              Image.network(leftImg, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
              Image.network(rightImg, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }


}



