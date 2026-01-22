import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (v) =>
                v!.length < 6 ? "Min 6 characters required" : null,
                decoration: const InputDecoration(labelText: "New Password"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    provider.resetPassword(
                      widget.email,
                      widget.otp,
                      _passwordController.text,
                      context,
                    );
                  }
                },
                child: const Text("Reset Password"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
