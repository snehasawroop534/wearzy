import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wearzy/auth_screens/auth_provider.dart';
import 'package:wearzy/auth_screens/login_screen.dart';
import 'package:wearzy/auth_screens/splash_screen.dart';

void main()
{
  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (context) => AuthProvider(),)],
      child: MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

