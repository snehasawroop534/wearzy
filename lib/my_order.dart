import 'package:flutter/material.dart';
import 'package:wearzy/order_details.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "My Orders",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search your order here",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.filter_alt_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(),));
              },

              child: ListView(
                children: [
                  orderTile(
                    img: "images/Tshirt.png",
                    date: "Delivered on Sep 20, 2023",
                    title: "GG_500 Vegetable & Fruit Chopper",
                    rated: false,
                  ),

                  orderTile(
                    img: "images/kurti.png",
                    date: "Delivered on Aug 25, 2023",
                    title: "Shell & Black Big Jhumka Combo",
                    rated: true,
                  ),

                  orderTile(
                    img: "images/silk saree.png",
                    date: "Delivered on Feb 09, 2023",
                    title: "Winget Men & Women Solid Socks",
                    rated: false,
                  ),

                  orderTile(
                    img: "images/suit.png",
                    date: "Delivered on May 07, 2022",
                    title: "Noise ColorFit Caliber Smartwatch",
                    sharedBy: "Shared by Ankit Raj",
                    rated: false,
                  ),

                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        "No more orders",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget orderTile({
    required String img,
    required String date,
    required String title,
    String? sharedBy,
    required bool rated,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              img,
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 8),

                rated
                    ? Row(
                  children: const [
                    Icon(Icons.star, color: Colors.green, size: 20),
                    Icon(Icons.star, color: Colors.green, size: 20),
                    Icon(Icons.star, color: Colors.green, size: 20),
                    Icon(Icons.star, color: Colors.green, size: 20),
                    Icon(Icons.star_border, color: Colors.green, size: 20),
                  ],
                )
                    : Row(
                  children: List.generate(
                    5,
                        (i) => const Icon(
                      Icons.star_border,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                rated
                    ? const Text(
                  "Write a Review",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w500),
                )
                    : const Text(
                  "Rate this product now",
                  style: TextStyle(color: Colors.grey),
                ),

                if (sharedBy != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      sharedBy,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ]
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
        ],
      ),
    );
  }
}
