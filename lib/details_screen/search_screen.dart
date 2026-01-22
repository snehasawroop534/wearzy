import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wearzy/details_screen/search_product_details.dart';
import 'package:wearzy/details_screen/single_product_screen.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../providers/search_product_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProductProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔝 Top Search Bar UI
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  /// Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  /// Search Field
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                          "Search by Product, Brand & more...",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Colors.grey),
                            onPressed: () async {
                              if (controller.text.isEmpty) return;

                              await provider.searchProducts(controller.text);

                              if (provider.searchList.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SearchProductDetails(),
                                  ),
                                );
                              }
                            },
                          ),


                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            provider.searchProducts(value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// 🔄 Loading
            if (provider.loading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),

            /// ❌ Error
            if (provider.error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  provider.error,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            /// 📦 Search Result List
            Expanded(
              child: ListView.builder(
                itemCount: provider.searchList.length,
                itemBuilder: (context, index) {
                  final item = provider.searchList[index];

                  return InkWell(
                    onTap: () {
                      final product = ProductModel(
                        null, // id
                        item.productId,
                        null, // categoryId (search api me nahi hai)
                        item.title,
                        item.brand,
                        item.mrp.toString(),
                        item.discountedPrice.toString(),
                        item.description,
                        "https://wearzy.edugaondev.com/productImages/${item.image}",
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SingleProductScreen(
                            product: product,
                          ),
                        ),
                      );
                    },

                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "https://wearzy.edugaondev.com/productImages/${item.image}", // 👈 image url / filename
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 55,
                              height: 55,
                              color: Colors.grey.shade800,
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        item.brand,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Text(
                        "₹${item.discountedPrice}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );

                },
              ),
            ),


          ],
        ),
      ),
    );
  }
}
