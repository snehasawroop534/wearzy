
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearzy/auth_screens/auth_api.dart';
import 'package:wearzy/bottom_nav_screens/bottom_navi_bar.dart';

import 'login_screen.dart';

class AuthProvider with ChangeNotifier{
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();


  loginNow(BuildContext context)async{
    var data = {
      "email":emailController.text,
      "password":passwordController.text,
    };
    var res = await AuthApi.login(data);
    if(res !=null){
      var sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool("login_status_key", true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successfully")));
      Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNaviBar(),));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed")));
    }

  }

  registerNow(BuildContext context)async{

    var sharedPref = await SharedPreferences.getInstance();

    sharedPref.setString("email_key", emailController.text.toString());
    sharedPref.setString("password_key", passwordController.text.toString());

    var data = {
      "name":nameController.text,
      "email":emailController.text,
      "password":"${passwordController.text}"


    };
    var res = await AuthApi.register(data);
    print("custom message ${res}");
    if(res !=null ){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Register Successfully")));
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Register Failed")));
    }

  }
}