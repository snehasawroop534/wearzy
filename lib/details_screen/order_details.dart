import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wearzy/details_screen/delivery_update_screen.dart';

import '../models/order_model.dart';
import '../providers/rating_provider.dart';

enum OrderStatus {
  confirmed,
  packed,
  dispatched,
  outForDelivery,
  delivered,
}

class OrderDetails extends StatefulWidget {
  final MyOrderModel order;

  const OrderDetails({super.key, required this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  @override
  void initState() {
    super.initState();

    final firstItem = widget.order.items.first;

    /// ✅ SAME RATING FETCH AS MY ORDER SCREEN
    Future.microtask(() {
      Provider.of<RatingProvider>(context, listen: false)
          .fetchRating(widget.order.orderId, firstItem.productId);
    });
  }

  OrderStatus getOrderStatus(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt).inMinutes;

    if (diff < 15) return OrderStatus.confirmed;
    if (diff < 30) return OrderStatus.packed;
    if (diff < 45) return OrderStatus.dispatched;
    if (diff < 60) return OrderStatus.outForDelivery;
    return OrderStatus.delivered;
  }

  String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return "Order Confirmed";
      case OrderStatus.packed:
        return "Packed";
      case OrderStatus.dispatched:
        return "Dispatched";
      case OrderStatus.outForDelivery:
        return "Out for Delivery";
      case OrderStatus.delivered:
        return "Delivered";
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = widget.order.items.first;
    final status = getOrderStatus(widget.order.createdAt);

    /// ✅ GET RATING FROM PROVIDER
    final rating = context
        .watch<RatingProvider>()
        .getRatingData(widget.order.orderId, firstItem.productId)
        ?.rating ??
        0;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text(
              "Help",
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // PRODUCT HEADING
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://wearzy.edugaondev.com/productImages/${firstItem.image}",
                      height: 65,
                      width: 65,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 65,
                        width: 65,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstItem.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),

                        Text(
                          firstItem.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "Order #${widget.order.orderId}",
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 20),

              // DELIVERY STATUS CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getStatusText(status),
                          style: TextStyle(
                            color: status == OrderStatus.delivered
                                ? Colors.green
                                : Colors.orange,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          status == OrderStatus.delivered
                              ? Icons.check_circle
                              : Icons.local_shipping,
                          color: status == OrderStatus.delivered
                              ? Colors.green
                              : Colors.orange,
                          size: 26,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      status == OrderStatus.delivered
                          ? "Your item has been delivered"
                          : "Your item is on the way",
                      style: const TextStyle(color: Colors.black87),
                    ),

                    const SizedBox(height: 18),

                    orderProgressBar(status),

                    const SizedBox(height: 8),

                    orderProgressLabels(),

                    const SizedBox(height: 10),

                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeliveryUpdateScreen(
                                createdAt: widget.order.createdAt,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "See all updates",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// ⬇️⬇️⬇️ EXISTING TEXT (UNCHANGED)
              const Text(
                "Rate your experience",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              /// ⭐⭐⭐⭐⭐ RATING SHOWN HERE
              Row(
                children: List.generate(
                  5,
                      (index) => Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              rating > 0
                  ? const Text(
                "You rated this product",
                style: TextStyle(color: Colors.blue),
              )
                  : const Text(
                "No rating given yet",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderProgressBar(OrderStatus status) {
    int current = status.index;

    return Row(
      children: List.generate(9, (index) {
        if (index.isEven) {
          int step = index ~/ 2;
          return Icon(
            Icons.check_circle,
            size: 20,
            color: step <= current ? Colors.green : Colors.grey.shade300,
          );
        } else {
          return Expanded(
            child: Container(
              height: 3,
              color: current >= (index ~/ 2)
                  ? Colors.green
                  : Colors.grey.shade300,
            ),
          );
        }
      }),
    );
  }

  Widget orderProgressLabels() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Confirmed", style: TextStyle(fontSize: 12)),
        Text("Packed", style: TextStyle(fontSize: 12)),
        Text("Dispatched", style: TextStyle(fontSize: 12)),
        Text("Out", style: TextStyle(fontSize: 12)),
        Text("Delivered", style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
