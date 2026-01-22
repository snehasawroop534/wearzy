import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/address_model.dart';
import '../providers/address_provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt("user_id");

    if (userId != null) {
      await Provider.of<AddressProvider>(context, listen: false)
          .fetchAddresses(userId);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Addresses",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              showAddAddressSheet();
            },

            child: const Text(
              "+ Add Address",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<AddressProvider>(
        builder: (context, provider, child) {
          if (provider.addresses.isEmpty) {
            return const Center(
              child: Text(
                "No address found",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Saved Addresses",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              /// 🔥 ADDRESS LIST
              ...provider.addresses.map((address) {
                return buildAddressCard(address);
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  /// 🔥 ADDRESS CARD UI
  Widget buildAddressCard(AddressModel address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ADDRESS TYPE BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              address.addressType.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          /// NAME
          Text(
            address.fullName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          /// FULL ADDRESS
          Text(
            "${address.houseNo}, ${address.city}, ${address.state}\nIndia - ${address.pincode}",
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 6),

          /// PHONE
          Text(
            "Phone : ${address.phone}",
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),

          const Divider(height: 24),

          /// ACTIONS
          Row(
            children: [
              InkWell(
                onTap: () async {
                  if (address.addressId == null) return;

                  final provider =
                  Provider.of<AddressProvider>(context, listen: false);

                  bool success =
                  await provider.deleteAddress(address.addressId!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? "Address deleted"
                            : "Failed to delete address",
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () {
                  showEditAddressSheet(address);
                },

                child: const Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }


  void showEditAddressSheet(AddressModel address) {
    final nameController = TextEditingController(text: address.fullName);
    final phoneController = TextEditingController(text: address.phone);
    final pincodeController = TextEditingController(text: address.pincode);
    final cityController = TextEditingController(text: address.city);
    final stateController = TextEditingController(text: address.state);
    final houseNoController = TextEditingController(text: address.houseNo);

    String selectedAddressType = address.addressType;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                      /// HEADER
                      Row(
                        children: const [
                          Text(
                            "Edit Address",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// CONTACT INFO
                      const Text("Contact Info",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      buildTextField("Name", controller: nameController),
                      buildTextField(
                        "Phone Number (+91)",
                        controller: phoneController,
                        keyboard: TextInputType.phone,
                      ),

                      const SizedBox(height: 20),

                      /// ADDRESS INFO
                      const Text("Address Info",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              "Pincode",
                              controller: pincodeController,
                              keyboard: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: buildTextField(
                              "City",
                              controller: cityController,
                            ),
                          ),
                        ],
                      ),

                      buildTextField("State", controller: stateController),
                      buildTextField(
                        "Flat no / Building / Area",
                        controller: houseNoController,
                      ),

                      const SizedBox(height: 20),

                      /// ADDRESS TYPE
                      const Text("Type of Address",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),

                      Row(
                        children: ["Home", "Office", "Other"]
                            .map(
                              (type) => Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedAddressType = type;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding:
                                const EdgeInsets.symmetric(vertical: 10),
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
                          ),
                        )
                            .toList(),
                      ),

                      const SizedBox(height: 24),

                      /// UPDATE BUTTON
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
                            final updatedAddress = AddressModel(
                              addressId: address.addressId,
                              userId: address.userId,
                              fullName: nameController.text,
                              phone: phoneController.text,
                              pincode: pincodeController.text,
                              state: stateController.text,
                              city: cityController.text,
                              houseNo: houseNoController.text,
                              addressType: selectedAddressType,
                            );

                            final success =
                            await Provider.of<AddressProvider>(
                              context,
                              listen: false,
                            ).updateAddress(
                              address.addressId!,
                              updatedAddress,
                            );

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? "Address updated successfully"
                                      : "Failed to update address",
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Update Address",
                            style:
                            TextStyle(fontSize: 16, color: Colors.white),
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

  void showAddAddressSheet() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final pincodeController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final houseNoController = TextEditingController();

    String selectedAddressType = "Home";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                      /// HEADER
                      const Text(
                        "Add Address",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      /// CONTACT INFO
                      const Text("Contact Info",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      buildTextField("Name", controller: nameController),
                      buildTextField(
                        "Phone Number (+91)",
                        controller: phoneController,
                        keyboard: TextInputType.phone,
                      ),

                      const SizedBox(height: 20),

                      /// ADDRESS INFO
                      const Text("Address Info",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              "Pincode",
                              controller: pincodeController,
                              keyboard: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: buildTextField(
                              "City",
                              controller: cityController,
                            ),
                          ),
                        ],
                      ),

                      buildTextField("State", controller: stateController),
                      buildTextField(
                        "Flat no / Building / Area",
                        controller: houseNoController,
                      ),

                      const SizedBox(height: 20),

                      /// ADDRESS TYPE
                      const Text("Type of Address",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),

                      Row(
                        children: ["Home", "Office", "Other"]
                            .map(
                              (type) => Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedAddressType = type;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding:
                                const EdgeInsets.symmetric(vertical: 10),
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
                          ),
                        )
                            .toList(),
                      ),

                      const SizedBox(height: 24),

                      /// ADD BUTTON
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
                            final prefs =
                            await SharedPreferences.getInstance();
                            final userId = prefs.getInt("user_id");

                            if (userId == null) return;

                            final newAddress = AddressModel(
                              userId: userId,
                              fullName: nameController.text,
                              phone: phoneController.text,
                              pincode: pincodeController.text,
                              state: stateController.text,
                              city: cityController.text,
                              houseNo: houseNoController.text,
                              addressType: selectedAddressType,
                            );

                            await Provider.of<AddressProvider>(
                              context,
                              listen: false,
                            ).addAddress(newAddress);

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Address added successfully"),
                              ),
                            );
                          },
                          child: const Text(
                            "Add Address",
                            style:
                            TextStyle(fontSize: 16, color: Colors.white),
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


  Widget buildTextField(
      String hint, {
        TextEditingController? controller,
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          hintText: hint,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }




}
