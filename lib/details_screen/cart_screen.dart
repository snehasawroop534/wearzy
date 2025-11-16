import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Bag (2 products)",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.favorite_border, color: Colors.black),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.blue.shade50,
              child: Row(
                children: const [
                  Icon(Icons.location_on_outlined, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Enter Pincode to check delivery date",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
            buildCartItem(
              assetImage: "images/Tshirt.png",
              brand: "Hivora",
              title: "Women Popcorn Shirt & Pants Co-Ords Set",
              size: "4XL",
              qty: "1",
              price: "₹675",
              oldPrice: "₹2,499",
              discount: "73%",
              save: "₹1,824",
            ),

            buildCartItem(
              assetImage: "images/kurti.png",
              brand: "FUSIONIC",
              title: "Women Floral Anarkali Kurta Set",
              size: "L",
              qty: "1",
              price: "₹1,968",
              oldPrice: "₹4,100",
              discount: "52%",
              save: "₹2,132",
            ),

            const SizedBox(height: 20),

            buildSection(
              title: "Apply coupon",
              trailing: const Text(
                "Select",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),

            buildSuperCash(),

            buildRedemptionOptions(),

            buildOrderDetails(),

            buildReturnPolicy(),

            const SizedBox(height: 80),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Row(
          children: [
            const Text(
              "₹2,672.00",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Add Address",
                style:
                TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCartItem({
    required String assetImage,
    required String brand,
    required String title,
    required String size,
    required String qty,
    required String price,
    required String oldPrice,
    required String discount,
    required String save,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.only(bottom: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              assetImage,
              height: 140,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    buildDropdown("Size", size),
                    const SizedBox(width: 10),
                    buildDropdown("Qty", qty),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      oldPrice,
                      style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "($discount)",
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),

                Text(
                  "You save $save",
                  style: const TextStyle(
                      color: Colors.green, fontSize: 13),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(right: 12, top: 10),
            child: Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(String label, String value) {
    return Container(
      height: 33,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(label),
          const SizedBox(width: 6),
          Text(value),
          const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }

  Widget buildSection({required String title, required Widget trailing}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailing,
    );
  }

  Widget buildSuperCash() {
    return ListTile(
      leading: const Icon(Icons.wallet_giftcard_outlined, color: Colors.green),
      title: const Text(
        "SuperCash",
        style: TextStyle(fontSize: 16),
      ),
      subtitle: const Text(
        "Earn ₹200.0 SuperCash on this order",
        style: TextStyle(color: Colors.green),
      ),
      trailing: const Text(
        "Know more",
        style: TextStyle(
            color: Colors.blue, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget buildRedemptionOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            "Redemption Options",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: const Text(
            "Verify that it's you",
            style: TextStyle(color: Colors.blue),
          ),
          subtitle: const Text(
              "To use Redemption Options Verify that it's you"),
        ),
        ListTile(
          leading: const Icon(Icons.radio_button_unchecked),
          title: const Text("Loyalty Points"),
          subtitle: const Text("You have no Loyalty Points at the moment"),
          trailing: const Text("Details",
              style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget buildOrderDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            "Order Details",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),

        buildAmountRow("Bag Total", "₹6,599.00"),
        buildAmountRow("Bag Savings", "-₹3,956.00", green: true),
        buildAmountRow("Coupon Savings", "Apply coupon"),
        buildAmountRow("Delivery Fee", "Free ₹99.00"),
        buildAmountRow("Platform Fee", "₹29.00"),

        const Divider(),

        buildAmountRow("Amount Payable", "₹2,672.00", bold: true),
      ],
    );
  }

  Widget buildAmountRow(String label, String value,
      {bool green = false, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: green ? Colors.green : Colors.black,
              fontSize: bold ? 17 : 15,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }

  Widget buildReturnPolicy() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Return/Refund policy",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "In case of return, we ensure quick refunds. Full amount will be refunded excluding Convenience Fee",
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: 6),
          Text(
            "Read policy",
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
