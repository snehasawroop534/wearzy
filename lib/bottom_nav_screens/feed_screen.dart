import 'package:flutter/material.dart';
import 'dart:async';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  bool showImages = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showImages = true;
      });
    });
  }

  Widget shimmerBox(double h, double w) {
    return Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(6),
      ),
      child: AnimatedOpacity(
        opacity: 0.4,
        duration: const Duration(milliseconds: 700),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[900]!,
                Colors.grey[700]!,
                Colors.grey[900]!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<Map<String, String>> brandList = [
    {"title": "BT", "subtitle": "TheBTclub"},
    {"title": "WLK", "subtitle": "WOMANLIKE"},
    {"title": "L", "subtitle": "Litt"},
    {"title": "BT", "subtitle": "TheBTclub"},
    {"title": "W", "subtitle": "Wearzy"},
  ];

  final List<Map<String, String>> categories = [
    {
      "image": "https://images.unsplash.com/photo-1520975916090-3105956dac38?w=500",
      "label": "New Arrivals"
    },
    {
      "image": "https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=500",
      "label": "Men"
    },
    {
      "image": "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500",
      "label": "WOMEN"
    },
    {
      "image": "https://images.unsplash.com/photo-1519741497674-611481863552?w=500",
      "label": "FOOTWEAR"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.favorite_border, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
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
                      '1',
                      style: TextStyle(color: Colors.white, fontSize: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: brandList.length,
                itemBuilder: (context, index) {
                  final brand = brandList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.teal[100],
                          child: Text(
                            brand["title"]!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          brand["subtitle"]!,
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: categories.map((cat) {
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: showImages
                            ? Image.network(
                          cat["image"]!,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        )
                            : shimmerBox(80, 80),
                      ),
                      const SizedBox(height: 4),
                      Text(cat["label"]!,
                          style: const TextStyle(fontSize: 12, color: Colors.white)),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: showImages
                      ? Image.network(
                    "https://images.unsplash.com/photo-1521334884684-d80222895322?w=1000",
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                      : shimmerBox(150, double.infinity),
                ),
              ),
            ),

            const SizedBox(height: 20),

            for (int i = 0; i < 3; i++) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: categories.map((cat) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: showImages
                              ? Image.network(
                            cat["image"]!,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          )
                              : shimmerBox(80, 80),
                        ),
                        const SizedBox(height: 4),
                        Text(cat["label"]!,
                            style: const TextStyle(fontSize: 12, color: Colors.white)),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
            ],

          ],
        ),
      ),
    );
  }
}
