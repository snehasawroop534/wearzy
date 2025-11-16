import 'package:flutter/material.dart';

class DeliveryUpdateScreen extends StatefulWidget {
  const DeliveryUpdateScreen({super.key});

  @override
  State<DeliveryUpdateScreen> createState() => _DeliveryUpdateScreenState();
}

class _DeliveryUpdateScreenState extends State<DeliveryUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),


              Expanded(
                child: ListView(
                  children: [
                    buildTimelineTile(
                      isFirst: true,
                      isLast: false,
                      isActive: true,
                      title: "Order Confirmed",
                      date: "Sun, 20th Aug '23",
                      description: [
                        ["Your Order has been placed.", "Sun, 20th Aug '23 - 2:02pm"],
                        ["Seller has processed your order.", "Mon, 21st Aug '23 - 11:27am"],
                        ["Your item has been picked up by delivery partner.", "Tue, 22nd Aug '23 - 10:26am"],
                      ],
                    ),

                    buildTimelineTile(
                      isFirst: false,
                      isLast: false,
                      isActive: true,
                      title: "Shipped",
                      date: "Tue, 22nd Aug '23",
                      description: [
                        ["Ekart Logistics - FMPC2985294785", ""],
                        ["Your item has been shipped.", "Tue, 22nd Aug '23 - 10:30am"],
                        ["Your item has been received in the hub nearest to you", ""],
                      ],
                    ),

                    buildTimelineTile(
                      isFirst: false,
                      isLast: false,
                      isActive: true,
                      title: "Out For Delivery",
                      date: "Fri, 25th Aug '23",
                      description: [
                        ["Your item is out for delivery", "Fri, 25th Aug '23 - 9:49am"],
                      ],
                    ),

                    buildTimelineTile(
                      isFirst: false,
                      isLast: true,
                      isActive: true,
                      title: "Delivered",
                      date: "Fri, 25th Aug '23",
                      description: [
                        ["Your item has been delivered", "Fri, 25th Aug '23 - 12:41pm"],
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimelineTile({
    required bool isFirst,
    required bool isLast,
    required bool isActive,
    required String title,
    required String date,
    required List<List<String>> description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isActive ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),

            if (!isLast)
              Container(
                width: 2,
                height: 80,
                color: Colors.green,
              ),
          ],
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title  $date",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),

              ...description.map(
                    (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item[0],
                        style: const TextStyle(fontSize: 15),
                      ),
                      if (item[1].isNotEmpty)
                        Text(
                          item[1],
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
