import 'package:flutter/material.dart';
import 'package:wearzy/delivery_update_screen.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
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
                    child: Image.asset(
                      "images/Tshirt.png",
                      height: 65,
                      width: 65,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Stylish Tshirt",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Black",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Order #OD428937561882728400",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  )
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
                      children: const [
                        Text(
                          "Delivered, Aug 25, 2023",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.check_circle, color: Colors.green, size: 26),
                      ],
                    ),

                    const SizedBox(height: 6),
                    const Text(
                      "Your item has been delivered",
                      style: TextStyle(color: Colors.black87),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        Expanded(
                          child: Container(
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.green,
                          ),
                        ),
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Order Confirmed\nAug 20, 2023",
                            style: TextStyle(color: Colors.grey)),
                        Text("Delivered\nAug 25, 2023",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryUpdateScreen(),));
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

              // RATE EXPERIENCE
              const Text(
                "Rate your experience",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.check_box_outlined, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          "Product ratings",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      "Good",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.green),
                        Icon(Icons.star, color: Colors.green),
                        Icon(Icons.star, color: Colors.green),
                        Icon(Icons.star, color: Colors.green),
                        Icon(Icons.star_border, color: Colors.green),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),


              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "images/banner shoes.jpg",
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Delivery details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.home_outlined, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "B-14 harischandra nagar sipara, Patna, Bihar",
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(Icons.person_outline, size: 28),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Sneha Kumari  8102464230, 9142903025",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const Text(
                "Price details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    priceRow("Listing price", "₹999"),
                    priceRow("Selling price", "₹136"),
                    priceRow("Other discount", "-₹40", green: true),
                    priceRow("Total fees", "₹2"),
                    const Divider(),

                    priceRow("Total amount", "₹98", bold: true),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Image.asset("images/ruppess.png", height: 20),
                        const SizedBox(width: 10),
                        const Text(
                          "Payment method",
                          style: TextStyle(fontSize: 14),
                        ),
                        const Spacer(),
                        const Text(
                          "Cash On Delivery",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(
                        child: Text(
                          "📄  Download Invoice",
                          style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Order ID",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 4),
              const Text(
                "OD428937561882728400",
                style: TextStyle(color: Colors.blue),
              ),

              const SizedBox(height: 25),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Shop more from Wearzy",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // PRICE ROW WIDGET
  Widget priceRow(String title, String value,
      {bool bold = false, bool green = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: green ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
