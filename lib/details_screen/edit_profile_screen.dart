import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController screenNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  DateTime? selectedDob;
  String gender = 'Female';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final pref = await SharedPreferences.getInstance();

    setState(() {
      firstNameController.text = pref.getString("first_name") ?? "";
      lastNameController.text = pref.getString("last_name") ?? "";
      screenNameController.text = pref.getString("screen_name") ?? "";
      emailController.text = pref.getString("email") ?? "";

      final dobString = pref.getString("dob");
      if (dobString != null) {
        selectedDob = DateTime.tryParse(dobString);
      }

      gender = pref.getString("gender") ?? "Female";
    });
  }

  Future<void> saveUserData() async {
    final pref = await SharedPreferences.getInstance();

    await pref.setString("first_name", firstNameController.text);
    await pref.setString("last_name", lastNameController.text);
    await pref.setString("screen_name", screenNameController.text);
    await pref.setString("email", emailController.text);

    if (selectedDob != null) {
      await pref.setString("dob", selectedDob!.toIso8601String());
    }

    await pref.setString("gender", gender);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    screenNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDob = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("First Name*", style: TextStyle(fontSize: 16)),
            TextField(controller: firstNameController),
            const SizedBox(height: 20),

            const Text("Last Name*", style: TextStyle(fontSize: 16)),
            TextField(controller: lastNameController),
            const SizedBox(height: 20),

            const Text("Screen Name*", style: TextStyle(fontSize: 16)),
            TextField(controller: screenNameController),
            const SizedBox(height: 20),

            const Text("Email Address*", style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: emailController,
                    readOnly: true,
                    decoration: const InputDecoration(),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final newEmail = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        TextEditingController temp = TextEditingController();
                        return AlertDialog(
                          title: const Text("Change Email"),
                          content: TextField(
                            controller: temp,
                            decoration: const InputDecoration(hintText: "Enter new email"),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () => Navigator.pop(context, temp.text),
                                child: const Text("Save")),
                          ],
                        );
                      },
                    );

                    if (newEmail != null && newEmail.isNotEmpty) {
                      setState(() => emailController.text = newEmail);
                    }
                  },
                  child: const Text("Change", style: TextStyle(color: Colors.blue)),
                )
              ],
            ),

            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Date of birth", style: TextStyle(fontSize: 15)),
                  const SizedBox(height: 10),
                  GestureDetector(
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
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text("Gender", style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Radio(
                  value: "Female",
                  groupValue: gender,
                  onChanged: (v) => setState(() => gender = v!),
                ),
                const Text("Female"),
                const SizedBox(width: 20),
                Radio(
                  value: "Male",
                  groupValue: gender,
                  onChanged: (v) => setState(() => gender = v!),
                ),
                const Text("Male"),
              ],
            ),

            const SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      firstNameController.clear();
                      lastNameController.clear();
                      screenNameController.clear();
                      emailController.clear();
                      setState(() {
                        selectedDob = null;
                        gender = "Female";
                      });
                    },
                    child: const Text("Reset", style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await saveUserData();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text("Update", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
