import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/home/widgets/home_body.dart';
import 'package:omeg_bazaar/screens/product/products_page.dart';
import 'package:omeg_bazaar/screens/profile/Profile.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:omeg_bazaar/widgets/common/app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Create pages list inside build so we can use setState in callbacks
    final List<Widget> pages = [
      HomeBody(
        onSeeAllPressed: () {
          setState(() {
            _currentIndex = 1;
          });
        },
      ),
      const ProductsPage(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: OmAppBar(title: 'Omeg-Bazaar', cartItemCount: 1),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: AppColour.primaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Products'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
