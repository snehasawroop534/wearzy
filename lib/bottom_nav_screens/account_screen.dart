import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearzy/auth_screens/login_screen.dart';
import 'package:wearzy/details_screen/edit_profile_screen.dart';
import 'package:wearzy/details_screen/my_order.dart';
import 'package:wearzy/details_screen/refund_cancellation_policy.dart';
import 'package:wearzy/details_screen/terms_conditions.dart';
import '../api_services/auth_api.dart';
import '../details_screen/address_screen.dart';
import '../providers/profile_provider.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String userName = "";
  String userEmail = "";
  File? profileImage;

  final List<Map<String, String>> accountOptions = [
    {"title": "Orders"},
    // {"title": "Customer Care"},
    // {"title": "Invite Friends & Earn", "subtitle": "You get ₹100 SuperCash for every friend"},
    // {"title": "AJIO Wallet", "subtitle": "Add Gift Card | Manage rewards and refunds"},
    // {"title": "Saved Cards"},
    // {"title": "My Rewards"},
    {"title": "Address"},
    // {"title": "Notifications"},
    // {"title": "Return Creation Demo"},
    // {"title": "How To Return"},
    // {"title": "How Do I Redeem My Coupon?"},
     {"title": "Terms & Conditions"},
    // {"title": "Promotions Terms & Conditions"},
     {"title": "Refund & Cancellation Policy"},
    // {"title": "We Respect Your Privacy"},
    // {"title": "Fees & Payments"},
    // {"title": "Who We Are"},
    // {"title": "Join Our Team"},
  ];

  @override
  void initState() {
    super.initState();
    loadUserData();

    // Fetch API profile via Provider
    Future.microtask(() {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
    });
  }

  // ---------------- LOAD USER DATA ----------------
  Future<void> loadUserData() async {
    final pref = await SharedPreferences.getInstance();
    final firstName = pref.getString("first_name") ?? "";
    final lastName = pref.getString("last_name") ?? "";
    String? imagePath = pref.getString("profile_pic");

    setState(() {
      userName = "$firstName $lastName".trim();
      userEmail = pref.getString("email") ?? "";
      if (imagePath != null && imagePath.isNotEmpty) {
        profileImage = File(imagePath);
      } else {
        profileImage = null;
      }
    });
  }

  // ---------------- DELETE PROFILE IMAGE ----------------
  Future<void> deleteProfileImage() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove("profile_pic");

    setState(() {
      profileImage = null;
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile photo removed")),
    );
  }

  // ---------------- LOGOUT ----------------
  Future<void> logout(BuildContext context) async {
    Navigator.pop(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    bool success = await AuthApi.logout();

    Navigator.pop(context);

    if (success) {
      final prefs = await SharedPreferences.getInstance();

      // 🔥 CLEAR ALL LOCAL DATA
      await prefs.clear();

      // 🔥 CLEAR PROVIDER DATA
      Provider.of<ProfileProvider>(context, listen: false).clearProfile();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged out successfully")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    }
  }


  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProfileProvider>(context);
    var p = provider.profile;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0F),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF1A1A1C),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      _getInitials(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p?.name ?? "Your Name",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),
                        Text(
                          p?.email ?? "email@example.com",
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),

                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                      loadUserData();
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        color: Color(0xFFC9857C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: accountOptions.length,
                itemBuilder: (context, index) {
                  final item = accountOptions[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          item["title"]!,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        subtitle: item["subtitle"] != null
                            ? Text(
                          item["subtitle"]!,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        )
                            : null,
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                        onTap: () {
                          if (item["title"] == "Orders") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyOrder()),
                            );
                          }

                          if (item["title"] == "Address") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddressScreen()),
                            );
                          }

                          if (item["title"] == "Terms & Conditions") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TermsConditions()),
                            );
                          }

                          if (item["title"] == "Refund & Cancellation Policy") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RefundCancellationPolicy()),
                            );
                          }

                        },



                      ),
                      const Divider(color: Colors.black54, height: 0),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFC9857C), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        showDialog(context: context, builder: (context) => dialogBox());
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Color(0xFFC9857C),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Version 9.24.0  Build 3514",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- INITIALS ----------------
  String _getInitials() {
    var provider = Provider.of<ProfileProvider>(context);
    final name = provider.profile?.name;

    if (name != null && name.trim().isNotEmpty) {
      return name.trim()[0].toUpperCase();
    }
    return "U";
  }


  // ---------------- LOGOUT DIALOG ----------------
  Widget dialogBox() {
    return AlertDialog(
      title: const Text("Are you sure?", style: TextStyle(fontSize: 18)),
      elevation: 5,
      actions: [
        TextButton(
          onPressed: () {
            logout(context);
          },
          child: const Text("Yes", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("No"),
        ),
      ],
    );
  }
}
