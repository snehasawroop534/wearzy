import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wearzy/providers/address_provider.dart';
import 'package:wearzy/providers/auth_provider.dart';
import 'package:wearzy/auth_screens/splash_screen.dart';
import 'package:wearzy/providers/cart_provider.dart';
import 'package:wearzy/providers/category_provider.dart';
import 'package:wearzy/providers/get_cart_provider.dart';
import 'package:wearzy/providers/order_provider.dart';
import 'package:wearzy/providers/product_provider.dart';
import 'package:wearzy/providers/profile_provider.dart';
import 'package:wearzy/providers/rating_provider.dart';
import 'package:wearzy/providers/search_product_provider.dart';
import 'package:wearzy/providers/wishlist_provider.dart';



void main()
{
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider(),),
    ChangeNotifierProvider(create: (context) => ProductProvider(),),
    ChangeNotifierProvider(create: (context) => ProfileProvider(),),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => GetCartProvider()),
    ChangeNotifierProvider(create: (_) => WishlistProvider()),
    ChangeNotifierProvider(create: (_) => SearchProductProvider()),
    ChangeNotifierProvider(create: (_) => AddressProvider()),
    ChangeNotifierProvider(create: (_) => OrderProvider()),
    ChangeNotifierProvider(create: (_) => RatingProvider()),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),


  ],
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

