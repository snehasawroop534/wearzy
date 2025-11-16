import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:wearzy/details_screen/cart_screen.dart';
import 'package:wearzy/details_screen/cloth_details.dart';
import 'package:wearzy/details_screen/favourite_screen.dart';

class ClothScreen extends StatefulWidget {
  const ClothScreen({super.key});

  @override
  State<ClothScreen> createState() => _ClothScreenState();
}

class _ClothScreenState extends State<ClothScreen> {
  final List<Map<String, dynamic>> products = [
    {
      "image": "images/Tshirt.png",
      "brand": "Hivora",
      "title": "Women Popcorn Shirt & Pants Co-Ords Set",
      "rating": "2.3",
      "reviews": "22",
      "price": "₹675",
      "oldPrice": "₹2499",
      "discount": "73% off",
      "offer": "Offer Price ₹540"
    },
    {
      "image": "images/kurti.png",
      "brand": "THE HOLLANDER",
      "title": "Women Cotton Solid Oversized Drop shoulder T-Shirt",
      "rating": "—",
      "reviews": "",
      "price": "₹500",
      "oldPrice": "₹999",
      "discount": "50% off",
      "offer": "Best Price ₹428"
    },
    {
      "image": "images/silk saree.png",
      "brand": "Xpose",
      "title": "Women Fit & Flare Denim Shirt Dress",
      "rating": "—",
      "reviews": "",
      "price": "₹2339",
      "oldPrice": "₹2599",
      "discount": "10% off",
      "offer": ""
    },
    {
      "image": "images/suit.png",
      "brand": "Fashion Booms",
      "title": "Women Relaxed Fit Trousers with Elasticated Waist",
      "rating": "3.1",
      "reviews": "116",
      "price": "₹750",
      "oldPrice": "₹1100",
      "discount": "32% off",
      "offer": ""
    },
    {
      "image": "images/Tshirt.png",
      "brand": "Hivora",
      "title": "Women Popcorn Shirt & Pants Co-Ords Set",
      "rating": "2.3",
      "reviews": "22",
      "price": "₹675",
      "oldPrice": "₹2499",
      "discount": "73% off",
      "offer": "Offer Price ₹540"
    },
    {
      "image": "images/kurti.png",
      "brand": "THE HOLLANDER",
      "title": "Women Cotton Solid Oversized Drop shoulder T-Shirt",
      "rating": "—",
      "reviews": "",
      "price": "₹500",
      "oldPrice": "₹999",
      "discount": "50% off",
      "offer": "Best Price ₹428"
    },
    {
      "image": "images/silk saree.png",
      "brand": "Xpose",
      "title": "Women Fit & Flare Denim Shirt Dress",
      "rating": "—",
      "reviews": "",
      "price": "₹2339",
      "oldPrice": "₹2599",
      "discount": "10% off",
      "offer": ""
    },
    {
      "image": "images/suit.png",
      "brand": "Fashion Booms",
      "title": "Women Relaxed Fit Trousers with Elasticated Waist",
      "rating": "3.1",
      "reviews": "116",
      "price": "₹750",
      "oldPrice": "₹1100",
      "discount": "32% off",
      "offer": ""
    },
    {
      "image": "images/Tshirt.png",
      "brand": "Hivora",
      "title": "Women Popcorn Shirt & Pants Co-Ords Set",
      "rating": "2.3",
      "reviews": "22",
      "price": "₹675",
      "oldPrice": "₹2499",
      "discount": "73% off",
      "offer": "Offer Price ₹540"
    },
    {
      "image": "images/kurti.png",
      "brand": "THE HOLLANDER",
      "title": "Women Cotton Solid Oversized Drop shoulder T-Shirt",
      "rating": "—",
      "reviews": "",
      "price": "₹500",
      "oldPrice": "₹999",
      "discount": "50% off",
      "offer": "Best Price ₹428"
    },
    {
      "image": "images/silk saree.png",
      "brand": "Xpose",
      "title": "Women Fit & Flare Denim Shirt Dress",
      "rating": "—",
      "reviews": "",
      "price": "₹2339",
      "oldPrice": "₹2599",
      "discount": "10% off",
      "offer": ""
    },
    {
      "image": "images/suit.png",
      "brand": "Fashion Booms",
      "title": "Women Relaxed Fit Trousers with Elasticated Waist",
      "rating": "3.1",
      "reviews": "116",
      "price": "₹750",
      "oldPrice": "₹1100",
      "discount": "32% off",
      "offer": ""
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(),));
              },
              child: Stack(
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.red,
                      child: const Text(
                        '2',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.66,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final item = products[index];
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ClothDetails(),));
                      },
                      child: Stack(
                        children: [
                          Image.asset(
                            item["image"],
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
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
                              child: LikeButton(
                                size: 20,
                                likeBuilder: (isLiked) {
                                  return Icon(
                                    isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                    color: isLiked ? Colors.pink : Colors.grey,
                                    size: 20,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      item["brand"],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      item["title"],
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (item["rating"] != "—")
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green[800],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item["rating"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                            const Icon(Icons.star,
                                color: Colors.white, size: 10),
                            Text(
                              " (${item["reviews"]})",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text(
                          item["price"],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item["oldPrice"],
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item["discount"],
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  if (item["offer"].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item["offer"],
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF121212),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.sort, color: Colors.white70),
                const SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFF1A1A1A),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        String selectedOption = "Relevance";

                        return StatefulBuilder(
                          builder: (context, setState) {
                            final options = [
                              "Relevance",
                              "Discount",
                              "Price (lowest first)",
                              "What's New",
                              "Price (highest first)",
                              "Ratings"
                            ];

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Sort By",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ...options.map((option) {
                                    return Column(
                                      children: [
                                        RadioListTile<String>(
                                          contentPadding: EdgeInsets.zero,
                                          value: option,
                                          groupValue: selectedOption,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedOption = value!;
                                            });
                                          },
                                          activeColor: Color(0xffcf8a7d),
                                          title: Text(
                                            option,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const Divider(color: Colors.transparent, height: 0),
                                      ],
                                    );
                                  }).toList(),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );

                  },
                    child: const Text("SORT BY", style: TextStyle(color: Colors.white))),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.category, color: Colors.white70),
                const SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFF1A1A1A),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        final List<Map<String, dynamic>> categories = [
                          {"name": "Women", "count": 99773},
                          {"name": "Men", "count": 76555},
                          {"name": "Tech", "count": 864},
                          {"name": "Toys & Baby Care", "count": 545},
                          {"name": "Home & Kitchen", "count": 250},
                          {"name": "Boys", "count": 75},
                          {"name": "Girls", "count": 74},
                          {"name": "Infants", "count": 2},
                        ];

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Category",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "View all filters",
                                    style: TextStyle(
                                      color: Color(0xffc9857c),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: categories.length,
                                  separatorBuilder: (_, __) =>
                                  const Divider(color: Colors.transparent, height: 10),
                                  itemBuilder: (context, index) {
                                    final item = categories[index];
                                    return InkWell(
                                      onTap: () {},
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: item["name"],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: " (${item["count"]})",
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.chevron_right,
                                            color:Color(0xffcf8a7d),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 20),
                              const Divider(color: Colors.transparent, height: 0),

                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color:Color(
                                            0xffc9857c), width: 1.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:Color(0xffc9857c),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Apply Filter",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );

                  },
                    child: const Text("CATEGORY", style: TextStyle(color: Colors.white))),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.filter_list, color: Colors.white70),
                const SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFF1A1A1A),
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            String selectedCategory = "Gender";
                            final filterCategories = [
                              "Gender",
                              "Category",
                              "Price",
                              "Brands",
                              "Occasion",
                              "Discount",
                              "Colors",
                              "Size & Fit",
                              "Tags",
                              "Rating",
                            ];

                            final genderOptions = [
                              {"title": "Women", "count": "99742"},
                              {"title": "Men", "count": "76516"},
                              {"title": "Tech", "count": "864"},
                              {"title": "Toys & Baby Care", "count": "545"},
                              {"title": "Home & Kitchen", "count": "250"},
                              {"title": "Boys", "count": "75"},
                              {"title": "Girls", "count": "74"},
                              {"title": "Infants", "count": "2"},
                            ];

                            Map<String, bool> selectedOptions = {};

                            return Container(
                              height: MediaQuery.of(context).size.height * 0.85,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                                      const Text(
                                        "Filters (177519 products)",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 18),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2A2A2A),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: ListView.builder(
                                            itemCount: filterCategories.length,
                                            itemBuilder: (context, index) {
                                              final cat = filterCategories[index];
                                              final isSelected = selectedCategory == cat;

                                              return InkWell(
                                                onTap: () {
                                                  setState(() => selectedCategory = cat);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent,
                                                    border: Border(
                                                      left: BorderSide(
                                                        color: isSelected ? const Color(
                                                            0xFFCF8A7D) : Colors.transparent,
                                                        width: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    cat,
                                                    style: TextStyle(
                                                      color: isSelected ? Colors.white : Colors.grey,
                                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: genderOptions.length,
                                            itemBuilder: (context, index) {
                                              final option = genderOptions[index];
                                              final title = option["title"]!;
                                              final count = option["count"]!;
                                              final isChecked = selectedOptions[title] ?? false;

                                              return CheckboxListTile(
                                                activeColor: const Color(
                                                    0xFFC9857C),
                                                value: isChecked,
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedOptions[title] = value!;
                                                  });
                                                },
                                                checkboxShape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                side: const BorderSide(color: Color(
                                                    0xFFCF8A7D)),
                                                title: Text(
                                                  "$title ($count)",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                controlAffinity: ListTileControlAffinity.leading,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {},
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Color(
                                                0xFFC8847C)),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text("Reset"),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                                0xFFC9857C),
                                            foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text("Apply Filter"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },

                    child: const Text("FILTERS", style: TextStyle(color: Colors.white))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
