
import 'package:flutter/material.dart';
import 'package:wearzy/bottom_nav_screens/account_screen.dart';
import 'package:wearzy/bottom_nav_screens/category_screen.dart';
import 'package:wearzy/bottom_nav_screens/home_screen.dart';
import 'package:wearzy/bottom_nav_screens/explore_screen.dart';

class BottomNaviBar extends StatefulWidget {
  const BottomNaviBar({super.key});

  @override
  State<BottomNaviBar> createState() => _BottomNaviBarState();
}

class _BottomNaviBarState extends State<BottomNaviBar> {
  int _selectedIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    ExploreScreen(),
    CategoryScreen(),
    AccountScreen()
  ];

  void _onTapedItem(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xffc9857c),
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black87,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell_outlined),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Account",
          ),
        ],
        onTap: _onTapedItem,
        currentIndex: _selectedIndex,
      ),
    );
  }

}
