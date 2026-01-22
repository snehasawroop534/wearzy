import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearzy/api_services/auth_api.dart';
import 'package:wearzy/bottom_nav_screens/bottom_navi_bar.dart';

import '../auth_screens/login_screen.dart';

class AuthProvider with ChangeNotifier {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();

  // -------------------------------------------------------------------
  // LOGIN
  // -------------------------------------------------------------------
  loginNow(BuildContext context) async {
    var data = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    var res = await AuthApi.login(data);

    if (res != null) {
      String accessToken = res["accessToken"];
      String refreshToken = res["refreshToken"];
      int userId = res["userId"];

      var sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool("login_status_key", true);
      sharedPref.setString("access_token", accessToken);
      sharedPref.setString("refresh_token", refreshToken);
      sharedPref.setInt("user_id", userId);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Successfully")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNaviBar()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Failed")));
    }
  }

  // -------------------------------------------------------------------
  // REGISTER
  // -------------------------------------------------------------------
  registerNow(BuildContext context) async {
    var sharedPref = await SharedPreferences.getInstance();

    sharedPref.setString("email_key", emailController.text.toString());
    sharedPref.setString("password_key", passwordController.text.toString());

    var data = {
      "name": nameController.text,
      "email": emailController.text,
      "password": "${passwordController.text}"
    };

    var res = await AuthApi.register(data);
    print("custom message ${res}");

    if (res != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Register Successfully")));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Register Failed")));
    }
  }

  // *******************************************************************
  // ******************  FORGOT PASSWORD SECTION  **********************
  // *******************************************************************

  // -------------------------------------------------------------------
  // 1. SEND OTP
  // -------------------------------------------------------------------
  Future<bool> sendOtp(String email) async {
    var body = {
      "email": email,
    };

    var response = await AuthApi.sendOtp(body);

    if (response != null && response["message"] == "OTP sent successfully") {
      return true;
    } else {
      return false;
    }
  }

  // -------------------------------------------------------------------
  // 2. RESET PASSWORD
  // -------------------------------------------------------------------
  Future<bool> resetPassword(
      String email, String otp, String newPassword, BuildContext context) async {
    var data = {
      "email": email,
      "otp": otp,
      "newPassword": newPassword,
    };

    var response = await AuthApi.resetPassword(data);

    if (response != null && response["message"] == "Password reset successfully") {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password Reset Successfully")));

      // Redirect to login page
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));

      return true;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid OTP or Failed")));
      return false;
    }
  }
}


