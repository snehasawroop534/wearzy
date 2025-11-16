import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearzy/auth_screens/login_screen.dart';
import 'package:wearzy/details_screen/edit_profile_screen.dart';
import 'package:wearzy/my_order.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String userName = "";
  String userEmail = "";

  final List<Map<String, String>> accountOptions = [
    {"title": "Orders"},
    {"title": "Customer Care"},
    {"title": "Invite Friends & Earn", "subtitle": "You get ₹100 SuperCash for every friend"},
    {"title": "AJIO Wallet", "subtitle": "Add Gift Card | Manage rewards and refunds"},
    {"title": "Saved Cards"},
    {"title": "My Rewards"},
    {"title": "Address"},
    {"title": "Notifications"},
    {"title": "Return Creation Demo"},
    {"title": "How To Return"},
    {"title": "How Do I Redeem My Coupon?"},
    {"title": "Terms & Conditions"},
    {"title": "Promotions Terms & Conditions"},
    {"title": "Returns & Refunds Policy"},
    {"title": "We Respect Your Privacy"},
    {"title": "Fees & Payments"},
    {"title": "Who We Are"},
    {"title": "Join Our Team"},
  ];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final pref = await SharedPreferences.getInstance();

    final firstName = pref.getString("first_name") ?? "";
    final lastName = pref.getString("last_name") ?? "";

    setState(() {
      userName = "$firstName $lastName".trim();
      userEmail = pref.getString("email") ?? "";
    });
  }

  Future<void> logout(BuildContext context) async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("login_status_key", false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      "SK",
                      style: TextStyle(
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
                          userName.isEmpty ? "Your Name" : userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail.isEmpty ? "email@example.com" : userEmail,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );

                      loadUserData();
                    },
                    child: InkWell(
                      onTap: () {
                        showDialog(context: context, builder: (context) => editDialogBox(),);
                      },
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          color: Color(0xFFC9857C),
                          fontWeight: FontWeight.bold,
                        ),
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
                        trailing:  Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 14),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrder(),));
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF0E0E0F),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => dialogBox(),
                        );
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
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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


  Widget editDialogBox() {
    return AlertDialog(
      title: const Text("Are you sure?", style: TextStyle(fontSize: 18)),
      elevation: 5,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditProfileScreen(),));
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
