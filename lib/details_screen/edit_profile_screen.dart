import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  DateTime? selectedDob;
  String gender = 'Female';
  File? profileImage;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // ---------------- LOAD USER DATA ----------------
  Future<void> loadUserData() async {
    final pref = await SharedPreferences.getInstance();
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    var p = profileProvider.profile;

    setState(() {
      // NAME
      nameController.text = p?.name ?? pref.getString("first_name") ?? "";

      // EMAIL
      emailController.text = p?.email ?? pref.getString("email") ?? "";

      // DOB
      final dobString = pref.getString("dob");
      if (dobString != null) selectedDob = DateTime.tryParse(dobString);

      // GENDER
      gender = pref.getString("gender") ?? "Female";

      // IMAGE
      String? imgPath = pref.getString("profile_pic");
      if (imgPath != null && imgPath.isNotEmpty) {
        profileImage = File(imgPath);
      }
    });
  }

  // ---------------- SAVE SHARED PREF (DOB & Gender) ----------------
  Future<void> saveExtraLocalData() async {
    final pref = await SharedPreferences.getInstance();
    if (selectedDob != null) {
      await pref.setString("dob", selectedDob!.toIso8601String());
    }
    await pref.setString("gender", gender);
  }

  // ---------------- DATE PICKER ----------------
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedDob = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Update Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // ------------------- NAME -------------------
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("First Name*", style: TextStyle(fontSize: 16)),
            ),
            TextField(controller: nameController),
            const SizedBox(height: 20),

            // ------------------- EMAIL -------------------
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Email Address*", style: TextStyle(fontSize: 16)),
            ),
            TextField(controller: emailController),
            const SizedBox(height: 25),

            // ------------------- DOB -------------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: GestureDetector(
                onTap: pickDate,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDob == null
                          ? "Select date of birth"
                          : "${selectedDob!.day}/${selectedDob!.month}/${selectedDob!.year}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ------------------- GENDER -------------------
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Gender", style: TextStyle(fontSize: 16)),
            ),
            Row(
              children: [
                Radio(
                    value: "Female",
                    groupValue: gender,
                    onChanged: (v) => setState(() => gender = v!)),
                const Text("Female"),
                const SizedBox(width: 20),
                Radio(
                    value: "Male",
                    groupValue: gender,
                    onChanged: (v) => setState(() => gender = v!)),
                const Text("Male"),
              ],
            ),

            const SizedBox(height: 40),

            // ------------------- RESET + UPDATE BUTTONS -------------------
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      nameController.clear();
                      emailController.clear();
                      setState(() {
                        selectedDob = null;
                        gender = "Female";
                        profileImage = null;
                      });
                    },
                    child: const Text("Reset"),
                  ),
                ),

                const SizedBox(width: 20),

                /// ------------------ UPDATE BUTTON ------------------
                Expanded(
                  child: ElevatedButton(
                    onPressed: profileProvider.isUpdating
                        ? null
                        : () async {
                      // 1️⃣ API UPDATE CALL
                      bool success =
                      await profileProvider.updateProfile(
                        name: nameController.text,
                        email: emailController.text,
                      );

                      if (success) {
                        // 2️⃣ SAVE DOB + GENDER LOCALLY
                        await saveExtraLocalData();

                        // 3️⃣ SHOW SUCCESS
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profile Updated Successfully"),
                          ),
                        );

                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Update Failed!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: profileProvider.isUpdating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Update",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
