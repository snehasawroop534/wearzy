import 'package:flutter/material.dart';

enum OrderStatus {
  confirmed,
  packed,
  dispatched,
  outForDelivery,
  delivered,
}

class DeliveryUpdateScreen extends StatefulWidget {

  /// ✅ REAL ORDER CREATED AT (ADDED)
  final DateTime? createdAt;

  const DeliveryUpdateScreen({super.key, this.createdAt});

  @override
  State<DeliveryUpdateScreen> createState() => _DeliveryUpdateScreenState();
}

class _DeliveryUpdateScreenState extends State<DeliveryUpdateScreen> {

  /// SAME LOGIC as OrderDetails
  OrderStatus getOrderStatus(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt).inMinutes;

    if (diff < 15) return OrderStatus.confirmed;
    if (diff < 30) return OrderStatus.packed;
    if (diff < 45) return OrderStatus.dispatched;
    if (diff < 60) return OrderStatus.outForDelivery;
    return OrderStatus.delivered;
  }

  @override
  Widget build(BuildContext context) {

    /// ⚠️ Demo purpose: yahan dummy createdAt use ho raha
    /// Baad me tum yahin real order.createdAt bhej sakti ho
    final createdAt = widget.createdAt ??
        DateTime.now().subtract(const Duration(minutes: 40));

    final status = getOrderStatus(createdAt);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView(
                  children: [

                    buildTimelineTile(
                      isFirst: true,
                      isLast: false,
                      isActive: status.index >= OrderStatus.confirmed.index,
                      title: "Order Confirmed",
                      date: "Order placed",
                      description: [
                        ["Your order has been placed successfully", ""],
                      ],
                    ),

                    buildTimelineTile(
                      isFirst: false,
                      isLast: false,
                      isActive: status.index >= OrderStatus.packed.index,
                      title: "Packed",
                      date: "Item packed",
                      description: [
                        ["Seller has packed your item", ""],
                      ],
                    ),

                    buildTimelineTile(
                      isFirst: false,
                      isLast: false,
                      isActive: status.index >= OrderStatus.dispatched.index,
                      title: "Dispatched",
                      date: "Shipped",
                      description: [
                        ["Your item has been dispatched", ""],
                      ],
                    ),

                    buildTimelineTile(
                      isFirst: false,
                      isLast: false,
                      isActive:
                      status.index >= OrderStatus.outForDelivery.index,
                      title: "Out For Delivery",
                      date: "On the way",
                      description: [
                        ["Your item is out for delivery", ""],
                      ],
                    ),

                    buildTimelineTile(
                      isFirst: false,
                      isLast: true,
                      isActive: status == OrderStatus.delivered,
                      title: "Delivered",
                      date: "Completed",
                      description: [
                        ["Your item has been delivered", ""],
                      ],
                    ),
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
                color: isActive ? Colors.green : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            ),

            if (!isLast)
              Container(
                width: 2,
                height: 70,
                color: isActive ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title  •  $date",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 6),

              ...description.map(
                    (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    item[0],
                    style: TextStyle(
                      fontSize: 14,
                      color:
                      isActive ? Colors.black87 : Colors.grey,
                    ),
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
