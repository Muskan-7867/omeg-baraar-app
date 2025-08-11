import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/home/widgets/home_body.dart';
import 'package:omeg_bazaar/screens/product/products_page.dart';
import 'package:omeg_bazaar/screens/profile/myorders/my_orders.dart';
// import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:omeg_bazaar/widgets/common/app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      // Home Page
      LayoutBuilder(
        builder: (context, constraints) {
          return HomeBody(
            onSeeAllPressed: () {
              setState(() {
                _currentIndex = 1; // Switch to Products page
              });
            },
            screenWidth: constraints.maxWidth,
          );
        },
      ),
      // Products Page
      const ProductsPage(),
      // My Orders Page
      const MyOrders(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar:
          _currentIndex == 2
              ? null
              : OmAppBar(
                title: _getAppBarTitle(),
                isSmallScreen: isSmallScreen,
              ),
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'OMEG-BAZAAR';
      case 1:
        return 'Products';
      case 2:
        return 'My Orders';
      default:
        return 'OMEG-BAZAAR';
    }
  }

  Widget _buildBottomNavBar(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.widgets_outlined),
          selectedIcon: Icon(Icons.widgets),
          label: 'Products',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.shopping_bag),
          label: 'My Orders',
        ),
      ],
    );
  }
}
