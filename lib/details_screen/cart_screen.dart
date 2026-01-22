import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearzy/details_screen/favourite_screen.dart';
import 'package:wearzy/details_screen/order_confirmation_screen.dart';
import '../models/address_model.dart';
import '../providers/address_provider.dart';
import '../providers/get_cart_provider.dart';
import '../models/get_cart_model.dart';

class CartScreen extends StatefulWidget {

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();

}


class _CartScreenState extends State<CartScreen> {

  double calculateAmountPayable(GetCartProvider cartProvider) {
    final bagTotal =
    calculateBagTotal(cartProvider.cartList, quantityMap);

    final discountedTotal =
    calculateDiscountedTotal(cartProvider.cartList, quantityMap);

    const double platformFee = 29;
    const double deliveryFee = 0;
    const double couponSavings = 0;

    return discountedTotal + platformFee + deliveryFee - couponSavings;
  }


  double calculateBagTotal(List<GetCartModel> cartList, Map<int, int> qtyMap) {
    double total = 0;
    for (var item in cartList) {
      final qty = qtyMap[item.cartId!] ?? 1;
      final mrp = double.tryParse(item.product?.mrp ?? "0") ?? 0;
      total += mrp * qty;
    }
    return total;
  }

  double calculateDiscountedTotal(List<GetCartModel> cartList, Map<int, int> qtyMap) {
    double total = 0;
    for (var item in cartList) {
      final qty = qtyMap[item.cartId!] ?? 1;
      final price =
          double.tryParse(item.product?.discountedPrice ?? "0") ?? 0;
      total += price * qty;
    }
    return total;
  }

  void proceedToPayment() {
    final cartProvider =
    Provider.of<GetCartProvider>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(
          address: selectedAddress!,
          amount: calculateAmountPayable(cartProvider),


          /// 🔥 CART DATA PASS KAR RAHE HAIN
          cartItems: cartProvider.cartList,
          quantityMap: quantityMap,
        ),
      ),
    );
  }




  Future<void> saveSelectedAddress(int addressId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("selected_address_id", addressId);
  }

  Future<int?> loadSelectedAddressId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("selected_address_id");
  }


  AddressModel? selectedAddress;

  Future<void> saveQuantity(int cartId, int qty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cart_qty_$cartId', qty);
  }

  Future<int> loadQuantity(int cartId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('cart_qty_$cartId') ?? 1;
  }

  bool loading = true;

  /// ⭐ ONLY ADDITION (Qty state)
  Map<int, int> quantityMap = {};

  // ⭐ SIZE STATE
  Map<int, String> sizeMap = {};

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      setState(() => loading = false);
      return;
    }

    final cartProvider =
    Provider.of<GetCartProvider>(context, listen: false);

    /// ✅ STEP 1: fetch cart from API
    await cartProvider.fetchCart(userId);

    for (var item in cartProvider.cartList) {
      if (item.cartId != null) {
        final cartId = item.cartId!;

        quantityMap[cartId] = await loadQuantity(cartId);
        sizeMap[cartId] = await loadSize(cartId);
      }
    }


    /// 🔥 LOAD SAVED ADDRESS
    final addressProvider =
    Provider.of<AddressProvider>(context, listen: false);

    await addressProvider.fetchAddresses(userId);

    int? savedAddressId = await loadSelectedAddressId();

    if (savedAddressId != null) {
      try {
        selectedAddress = addressProvider.addresses.firstWhere(
              (addr) => addr.addressId == savedAddressId,
        );
      } catch (e) {
        selectedAddress = null;
      }
    }

    setState(() {
      loading = false;
    });
  }

  // 🔥 SAVE SIZE
  Future<void> saveSize(int cartId, String size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart_size_$cartId', size);
  }

// 🔥 LOAD SIZE
  Future<String> loadSize(int cartId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('cart_size_$cartId') ?? "M";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Consumer<GetCartProvider>(
          builder: (context, value, child) => Text(
            "Bag (${value.cartList.length} products)",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavouriteScreen()),
                );
              },
              child:
              const Icon(Icons.favorite_border, color: Colors.black),
            ),
          ),
        ],
      ),
      body: Consumer<GetCartProvider>(
        builder: (context, cartProvider, child) {
          if (loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cartProvider.cartList.isEmpty) {
            return const Center(child: Text("Your bag is empty"));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                   openChooseAddressBottomSheet(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.blue.shade50,
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.blue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            selectedAddress == null
                                ? "Enter Pincode to check delivery date"
                                : "${selectedAddress!.houseNo}, ${selectedAddress!.city} - ${selectedAddress!.pincode}",
                            style: const TextStyle(fontSize: 15),
                          ),

                        ),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),


                /// ⭐ CART ITEMS
                for (GetCartModel item in cartProvider.cartList)
                  buildCartItem(
                    item: item,
                    image:
                    "https://wearzy.edugaondev.com/productImages/${item.product?.image ?? ''}",
                    brand: item.product?.brand ?? "",
                    title: item.product?.title ?? "",
                    description:
                    item.product?.description ?? "",
                    size: "M",
                    discountedPrice:
                    "₹${item.product?.discountedPrice ?? '0'}",
                    mrp: "₹${item.product?.mrp ?? '0'}",
                  ),

                const SizedBox(height: 20),



               // buildSuperCash(),
               // buildRedemptionOptions(),
                buildOrderDetails(cartProvider),
                buildReturnPolicy(),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<GetCartProvider>(
        builder: (context, value, child) {

          /// 🔥 CASE 1: BAG EMPTY
          if (value.cartList.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child: Row(
                children: [

                  /// ✅ CONTINUE SHOPPING
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // back to shopping
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Continue Shopping",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// ✅ ADD FROM WISHLIST
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavouriteScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Add from Wishlist",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          /// 🔥 CASE 2: BAG HAS ITEMS (OLD LOGIC – SAME AS BEFORE)
          return Container(
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
                Text(
                  "₹${calculateAmountPayable(value).toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                GestureDetector(
                  onTap: () {
                    if (selectedAddress == null) {
                      openAddressBottomSheet(context);
                    } else {
                      proceedToPayment();
                    }
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedAddress == null
                          ? "Add Address"
                          : "Proceed to Payment",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ⭐ CART ITEM (UI SAME)
  Widget buildCartItem({
    required GetCartModel item,
    required String image,
    required String brand,
    required String title,
    required String description,
    required String size,
    required String discountedPrice,
    required String mrp,
  }) {
    // ✅ YAHI ADD KARNA HAI (METHOD KE START ME)
    final int cartKey = item.cartId!;
    final int qtyValue = quantityMap[cartKey] ?? 1;
    final String selectedSize = sizeMap[cartKey] ?? "M";



    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.only(bottom: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              image,
              height: 140,
              width: 110,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 80),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(brand,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54)),
                const SizedBox(height: 4),
                Text(description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  children: [

                    buildSizeDropdown(
                      cartId: cartKey,
                      selectedSize: selectedSize,
                    ),


                    const SizedBox(width: 10),

                    /// ⭐ Qty + / –
                    buildQtySelector(
                      cartId: item.cartId!,
                      qty: qtyValue,
                    ),

                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(discountedPrice,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                    const SizedBox(width: 8),
                    Text(mrp,
                        style: const TextStyle(
                            decoration:
                            TextDecoration.lineThrough,
                            color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),

          /// ⭐ DELETE (UNCHANGED)
          InkWell(
            onTap: () async {
              final provider =
              Provider.of<GetCartProvider>(context,
                  listen: false);

              bool deleted =
              await provider.removeItem(item.cartId ?? 0);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(deleted
                        ? "Item removed"
                        : "Failed to remove item")),
              );
            },
            child: const Padding(
              padding:
              EdgeInsets.only(right: 12, top: 10),
              child:
              Icon(Icons.delete_outline, color: Colors.red),
            ),
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

  Widget buildSizeDropdown({
    required int cartId,
    required String selectedSize,
  }) {
    return InkWell(
      onTap: () {
        openSizeBottomSheet(cartId);
      },
      child: Container(
        height: 33,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const Text("Size"),
            const SizedBox(width: 6),
            Text(
              selectedSize,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 18),
          ],
        ),
      ),
    );
  }

  void openSizeBottomSheet(int cartId) {
    final sizes = ["S", "M", "L", "XL", "XXL"];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Size",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: sizes.map((size) {
                  final bool isSelected = sizeMap[cartId] == size;

                  return ChoiceChip(
                    label: Text(size),
                    selected: isSelected,
                    selectedColor: Colors.black,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) async {
                      setState(() {
                        sizeMap[cartId] = size;
                      });

                      await saveSize(cartId, size);

                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }



  /// ⭐ Qty selector (ONLY NEW WIDGET)
  Widget buildQtySelector({
    required int cartId,
    required int qty,
  }) {
    return Container(
      height: 33,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              if (qty > 1) {
                int newQty = qty - 1;
                setState(() {
                  quantityMap[cartId] = newQty;
                });
                await saveQuantity(cartId, newQty);
              }
            },

            child: const Icon(Icons.remove, size: 18),
          ),
          const SizedBox(width: 8),
          Text(qty.toString(),
              style:
              const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          InkWell(
            onTap: () async {
              int newQty = qty + 1;
              setState(() {
                quantityMap[cartId] = newQty;
              });
              await saveQuantity(cartId, newQty);
            },

            child: const Icon(Icons.add, size: 18),
          ),
        ],
      ),
    );
  }

  // ⭐ STATIC SECTIONS (UNCHANGED)
  Widget buildSection({required String title, required Widget trailing}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailing,
    );
  }

  Widget buildSuperCash() {
    return ListTile(
      leading:
      const Icon(Icons.wallet_giftcard_outlined,
          color: Colors.green),
      title: const Text("SuperCash",
          style: TextStyle(fontSize: 16)),
      subtitle: const Text(
        "Earn ₹200.0 SuperCash on this order",
        style: TextStyle(color: Colors.green),
      ),
      trailing: const Text(
        "Know more",
        style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget buildRedemptionOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text("Redemption Options",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
        ),
        ListTile(
          title: const Text("Verify that it's you",
              style: TextStyle(color: Colors.blue)),
          subtitle: const Text(
              "To use Redemption Options Verify that it's you"),
        ),
        ListTile(
          leading:
          const Icon(Icons.radio_button_unchecked),
          title: const Text("Loyalty Points"),
          subtitle: const Text(
              "You have no Loyalty Points at the moment"),
          trailing: const Text("Details",
              style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget buildOrderDetails(GetCartProvider cartProvider) {
    final bagTotal =
    calculateBagTotal(cartProvider.cartList, quantityMap);

    final discountedTotal =
    calculateDiscountedTotal(cartProvider.cartList, quantityMap);

    final bagSavings = bagTotal - discountedTotal;
    const double platformFee = 29;
    const double deliveryFee = 0;
    const double couponSavings = 0;

    final amountPayable = calculateAmountPayable(cartProvider);

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

        buildAmountRow("Bag Total", "₹${bagTotal.toStringAsFixed(2)}"),

        buildAmountRow(
          "Bag Savings",
          "-₹${bagSavings.toStringAsFixed(2)}",
          green: true,
        ),

        buildAmountRow(
          "Coupon Savings",
          couponSavings == 0 ? "Apply coupon" : "-₹$couponSavings",
        ),

        buildAmountRow(
          "Delivery Fee",
          deliveryFee == 0 ? "Free" : "₹$deliveryFee",
        ),

        buildAmountRow("Platform Fee", "₹$platformFee"),

        const Divider(),

        buildAmountRow(
          "Amount Payable",
          "₹${amountPayable.toStringAsFixed(2)}",
          bold: true,
        ),
      ],
    );
  }


  Widget buildAmountRow(String label, String value,
      {bool green = false, bool bold = false}) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 15)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: green ? Colors.green : Colors.black,
              fontSize: bold ? 17 : 15,
              fontWeight:
              bold ? FontWeight.bold : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }

  Widget buildReturnPolicy() {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Return/Refund policy",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(
            "In case of return, we ensure quick refunds. Full amount will be refunded excluding Convenience Fee",
            style: TextStyle(color: Colors.black54),
          ),

        ],
      ),
    );
  }

  void openAddressBottomSheet(BuildContext context) {
    // ✅ Controllers for form fields
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final pincodeController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final localityController = TextEditingController();
    final houseNoController = TextEditingController();
    final landmarkController = TextEditingController();

    // ✅ Address type state
    String selectedAddressType = "Home";
    bool isDefault = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // HEADER
                      Row(
                        children: [
                          const Text(
                            "Add Address",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              // Reset all fields
                              nameController.clear();
                              phoneController.clear();
                              pincodeController.clear();
                              cityController.clear();
                              stateController.clear();
                              localityController.clear();
                              houseNoController.clear();
                              landmarkController.clear();
                              setState(() {
                                selectedAddressType = "Home";
                                isDefault = false;
                              });
                            },
                            child: const Text("Reset"),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Contact Info
                      const Text("Contact Info",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      buildTextField("Name", controller: nameController),
                      buildTextField("Phone Number (+91)",
                          controller: phoneController,
                          keyboard: TextInputType.phone),
                      const SizedBox(height: 20),

                      // Address Info
                      const Text("Address Info",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: buildTextField("Pincode",
                                  controller: pincodeController)),
                          const SizedBox(width: 10),
                          Expanded(
                              child:
                              buildTextField("City", controller: cityController)),
                        ],
                      ),
                      buildTextField("State", controller: stateController),
                      buildTextField("Locality / Area / Street",
                          controller: localityController),
                      buildTextField("Flat no / Building Name",
                          controller: houseNoController),
                      buildTextField("Landmark (optional)",
                          controller: landmarkController),
                      const SizedBox(height: 20),

                      // Address Type
                      const Text("Type of Address",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      Row(
                        children: ["Home", "Office", "Other"]
                            .map((type) => Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAddressType = type;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selectedAddressType == type
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(type),
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                      const SizedBox(height: 10),

                      // Default checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: isDefault,
                            onChanged: (val) {
                              setState(() {
                                isDefault = val ?? false;
                              });
                            },
                          ),
                          const Text("Make as default address"),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // SAVE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            // ✅ Collect all data
                            final provider = Provider.of<AddressProvider>(context,
                                listen: false);

                            final prefs = await SharedPreferences.getInstance();
                            final int? userId = prefs.getInt("user_id");

                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please login first")),
                              );
                              return;
                            }

                            final newAddress = AddressModel(
                              userId: userId, // Replace with actual userId
                              fullName: nameController.text,
                              phone: phoneController.text,
                              pincode: pincodeController.text,
                              state: stateController.text,
                              city: cityController.text,
                              houseNo: houseNoController.text,
                              addressType: selectedAddressType,
                            );

                            bool success =
                            await provider.addAddress(newAddress);

                            if (success) {
                              Navigator.pop(context);

                              // 🔥 Auto select newly added address
                              await provider.fetchAddresses(userId);

                              final lastAddress = provider.addresses.last;

                              setState(() {
                                selectedAddress = lastAddress;
                              });

                              if (lastAddress.addressId != null) {
                                await saveSelectedAddress(lastAddress.addressId!);
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Address added successfully")),
                              );
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Failed to add address")),
                              );
                            }
                          },
                          child: const Text(
                            "Save Address",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

// Modified buildTextField to accept controller
  Widget buildTextField(String hint,
      {TextEditingController? controller,
        TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          hintText: hint,
          // enabledBorder: const UnderlineInputBorder(
          //   borderSide: BorderSide(color: Colors.black26),
          // ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }


  Widget addressType(String title) {
    return Expanded(
      child: Row(
        children: [
          const Icon(Icons.radio_button_unchecked, size: 18),
          const SizedBox(width: 6),
          Text(title),
        ],
      ),
    );
  }

  void openChooseAddressBottomSheet(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt("user_id");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    // ✅ API CALL
    Provider.of<AddressProvider>(context, listen: false)
        .fetchAddresses(userId);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<AddressProvider>(
            builder: (context, addressProvider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE
                  const Text(
                    "Choose a delivery address",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔥 ADDRESS LIST
                  if (addressProvider.addresses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text("No address found")),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: addressProvider.addresses.length,
                      itemBuilder: (context, index) {
                        final address = addressProvider.addresses[index];

                        return InkWell(
                          onTap: () async {
                            setState(() {
                              selectedAddress = address;
                            });

                            // ✅ SAVE addressId
                            if (address.addressId != null) {
                              await saveSelectedAddress(address.addressId!);
                            }

                            Navigator.pop(context);
                          },

                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                /// LEFT DATA
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                              BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              address.addressType.toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            address.fullName,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        "${address.houseNo}, ${address.city}",
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      ),

                                      const SizedBox(height: 6),

                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                              "${address.state} ${address.pincode}"),
                                          const SizedBox(width: 12),
                                          const Icon(Icons.call,
                                              size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(address.phone),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  /// ADD NEW ADDRESS
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      openAddressBottomSheet(context);
                    },
                    child: const Text(
                      "Add new address",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ENTER PINCODE
                  const Text(
                    "Enter new pincode",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        );
      },
    );
  }

}
