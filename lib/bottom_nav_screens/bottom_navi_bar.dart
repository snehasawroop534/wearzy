
import 'package:flutter/material.dart';
import 'package:wearzy/bottom_nav_screens/account_screen.dart';
import 'package:wearzy/bottom_nav_screens/feed_screen.dart';
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
    FeedScreen(),
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
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: "Feed",
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
