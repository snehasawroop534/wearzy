import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wearzy/details_screen/cart_screen.dart';
import 'package:wearzy/details_screen/category_product_screen.dart';
import 'package:wearzy/details_screen/favourite_screen.dart';
import 'package:wearzy/details_screen/product_screen.dart';
import '../models/category_model.dart';
import '../providers/category_provider.dart';
import '../providers/get_cart_provider.dart';
import '../shimmers/cetegory_shimmer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch categories on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E0F),
        elevation: 0,
        title: const Text(
          "Shop By Category",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteScreen(),));
            },
          ),
          Stack(
            children: [
              IconButton(
                icon:
                const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(),));
                },
              ),
              Positioned(
                right: 6,
                top: 3,
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
        ],
      ),
      body: categoryProvider.isCategoryLoading
          ? const CategoryShimmer()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryProvider.categories.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final CategoryModel category = categoryProvider.categories[index];

                // 🔹 Category ke liye asset image mapping
                Map<String, String> categoryImages = {
                  "Men": "images/man.jpg",
                  "Women": "images/women.jpg",
                  "Kids": "images/kids.png",
                  "Footwear": "images/footwear.jpg",
                  "Jewellery": "images/jewellery.jpg",
                  "Accessories": "images/Accessories.jpg",
                  "Home & Lifestyle": "images/Home & Lifestyle.jpg",
                  "Collectibles": "images/Collectibles.jpg",
                };

                // Default image agar mapping me nahi hai
                final String imagePath = categoryImages[category.name] ?? "assets/images/default.jpg";

                return GestureDetector(
                  onTap: () async {
                    await categoryProvider.fetchProductsByCategory(category.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductScreen(
                          categoryId: category.id,
                          categoryName: category.name,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Text ke liye optional background (transparent bhi kar sakte ho)
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              category.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 8,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Brand Advertisement",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset("images/banw.jpeg")),

          ],
        ),
      ),
    );
  }
}
