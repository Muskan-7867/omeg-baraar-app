import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/profile/myorders/widgets/orders_tab_bar.dart';
import 'package:omeg_bazaar/screens/profile/Profile.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          // If OrderTapBar doesn't have its own Scaffold
          Expanded(child: OrderTapBar()),
        ],
      ),
    );
  }
}
