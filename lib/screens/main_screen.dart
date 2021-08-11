import 'package:car_driver/constant_text.dart';
import 'package:car_driver/style/brand_color.dart';
import 'package:car_driver/tabs/earnings_tab.dart';
import 'package:car_driver/tabs/home_tab.dart';
import 'package:car_driver/tabs/profile_tab.dart';
import 'package:car_driver/tabs/reatings_tab.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'mainpage';
  MainScreen({
    Key key,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int selectedIndex = 0;

  void onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            HomeTab(),
            EarningsTab(),
            ReatingsTab(),
            ProfileTab(),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: textBottomNavbarItem1),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), label: textBottomNavbarItem2),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), label: textBottomNavbarItem3),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: textBottomNavbarItem4),
        ],
        currentIndex: selectedIndex,
        unselectedItemColor: BrandColor.colorIcon,
        selectedItemColor: BrandColor.colorOrange,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12.0),
        type: BottomNavigationBarType.fixed,
        onTap: onItemClicked,
      ),
    );
  }
}
