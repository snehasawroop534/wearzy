import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearzy/bottom_nav_screens/bottom_navi_bar.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
      getData();

    });

  }

  getData() async {
    var sharedPref = await SharedPreferences.getInstance();

    bool status = sharedPref.getBool("login_status_key")??false;
    if(status){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNaviBar(),));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));

    }

  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xffc9857c),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset("images/Wearzy Logo.png",height: 250,width: 250,))

            ],

          ),

    ));
  }
}
