import 'package:flutter/material.dart';
import 'reset_password_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Enter OTP")),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            Text("OTP sent to: ${widget.email}"),

            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: "Enter OTP",
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen(
                      email: widget.email,
                      otp: _otpController.text,
                    ),
                  ),
                );
              },
              child: const Text("Verify OTP"),
            )
          ],
        ),
      ),
    );
  }
}
