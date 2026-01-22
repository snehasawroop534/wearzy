import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:wearzy/bottom_nav_screens/bottom_navi_bar.dart';
import 'package:wearzy/bottom_nav_screens/home_screen.dart';

import '../api_services/razorpay_api_service.dart';
import '../models/address_model.dart';
import '../models/get_cart_model.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final AddressModel address;
  final double amount;

  final List<GetCartModel> cartItems;
  final Map<int, int> quantityMap;


  const OrderConfirmationScreen({
    super.key,
    required this.address,
    required this.amount, required this.cartItems, required this.quantityMap,
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  Razorpay? _razorpay;
  bool _isUPISelected = false;


  bool _isCODSelected = false;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay?.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful")),
    );

    /// 🔥 Payment success ke baad ORDER PLACE
    _placeOrderAfterPayment();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  Future<void> _startRazorpayPayment() async {
    int amountInPaise = (widget.amount * 100).toInt();

    final orderId =
    await RazorpayApiService.getRazorPayApi(amountInPaise);

    if (orderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to create payment")),
      );
      return;
    }

    var options = {
      'key': 'rzp_test_RuGkfl8jgd5hXl',
      'amount': amountInPaise,
      'order_id': orderId,
      'name': 'Wearzy',
      'description': 'Order Payment',
      'prefill': {
        'contact': widget.address.phone,
        'email': 'test@wearzy.com',
      }
    };

    _razorpay!.open(options);
  }

  Future<void> _placeOrderAfterPayment() async {
    final orderProvider =
    Provider.of<OrderProvider>(context, listen: false);

    final orderItems = widget.cartItems.map((cartItem) {
      final qty = widget.quantityMap[cartItem.cartId] ?? 1;

      return OrderItem(
        productId: cartItem.productId!,
        quantity: qty,
        price: double.parse(cartItem.product?.discountedPrice ?? "0"),
      );
    }).toList();

    await orderProvider.placeOrder(
      userId: widget.address.userId,
      totalAmount: widget.amount,
      items: orderItems,
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => BottomNaviBar()),
          (route) => false,
    );
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        title: const Text(
          "Order Confirmation",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _addressTile(),
            _secureInfo(),
            _expectedDelivery(),
            _amountPayable(),
            _paymentSection(),

            if (_isCODSelected) _placeOrderButton(), // 👈 HERE

            const SizedBox(height: 30),
          ],
        ),
      ),

    );
  }

  Widget _addressTile() {
    return InkWell(
      onTap: () {

      },
      child: Container(
        height: 40,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "${widget.address.fullName} | "
                    "${widget.address.houseNo}, "
                    "${widget.address.city}, "
                    "${widget.address.state}",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Text(widget.address.pincode),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),

      ),
    );
  }

  Widget _secureInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: const Text(
        "Secure Payment | Genuine Products | Easy Returns",
        style: TextStyle(color: Colors.black54, fontSize: 13),
      ),
    );
  }

  Widget _expectedDelivery() {
    return ListTile(
      title: const Text("Expected Delivery"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text("26th Dec"),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
      subtitle: Row(
        children: const [
          Icon(Icons.card_giftcard, size: 16, color: Colors.green),
          SizedBox(width: 6),
          Text("Free Gifts with this Order"),
        ],
      ),
    );
  }

  Widget _amountPayable() {
    return ListTile(
      title: const Text("Amount Payable"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "₹${widget.amount.toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }


  Widget _paymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            "Payment",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _offerCard(),
        _paymentTile("Have a Gift Card?", "Add"),
        _paymentTile(
          "UPI (Pay using any App or UPI ID)",
          _isUPISelected ? "Selected" : "+",
          onTap: () {
            setState(() {
              _isUPISelected = true;
              _isCODSelected = false;
            });

            _startRazorpayPayment(); // 🔥 YAHI SE RAZORPAY OPEN
          },
        ),

        _paymentTile("Credit / Debit Card", "+ Add card"),
        _paymentTile("Net Banking", "+"),
        _paymentTile("Wallet", "+"),
        _paymentTile("EMI", "+"),
        _paymentTile(
          "Cash on Delivery",
          _isCODSelected ? "Selected" : "+",
          onTap: () {
            setState(() {
              _isCODSelected = !_isCODSelected;
            });
          },
        ),

      ],
    );
  }

  Widget _offerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: const [
          Expanded(
            child: Text(
              "Get 10% Instant Discount of up to Rs.1000 on minimum transaction value of Rs 3000 using selected ICICI Bank Credit Cards. T&C",
              style: TextStyle(fontSize: 13),
            ),
          ),
          SizedBox(width: 8),
          Text("ICICI",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _paymentTile(
      String title,
      String action, {
        bool disabled = false,
        VoidCallback? onTap,
      }) {
    return ListTile(
      onTap: disabled ? null : onTap,
      title: Text(
        title,
        style: TextStyle(color: disabled ? Colors.grey : Colors.black),
      ),
      trailing: Text(
        action,
        style: TextStyle(
          color: disabled
              ? Colors.grey
              : (action == "Selected" ? Colors.green : Colors.blue),
          fontWeight:
          action == "Selected" ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _placeOrderButton() {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              onPressed: orderProvider.isLoading
                  ? null
                  : () async {

                /// 🔥 CART → ORDER ITEMS
                final List<OrderItem> orderItems =
                widget.cartItems.map((cartItem) {
                  final int qty =
                      widget.quantityMap[cartItem.cartId] ?? 1;

                  return OrderItem(
                    productId: cartItem.productId!,
                    quantity: qty,
                    price: double.parse(
                      cartItem.product?.discountedPrice ?? "0",
                    ),
                  );
                }).toList();

                await orderProvider.placeOrder(
                  userId: widget.address.userId,
                  totalAmount: widget.amount,
                  items: orderItems,
                );

                if (orderProvider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(orderProvider.errorMessage!),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                /// ✅ SUCCESS
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Order placed successfully (ID: ${orderProvider.orderId})",
                    ),
                  ),
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => BottomNaviBar()),
                      (route) => false,
                );
              },


              child: orderProvider.isLoading
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Text(
                "Place Order",
                style:
                TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }
}
