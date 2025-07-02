import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/profile/myorders/widgets/orders_tab_bar.dart';
import 'package:omeg_bazaar/screens/profile/user_profile.dart';
import 'package:omeg_bazaar/screens/profile/widgets/services/profile_data_service.dart';

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
      body: FutureBuilder<Map<String, dynamic>>(
        future: ProfileDataService.loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load orders'),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Retry loading
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!['userOrders'] == null ||
              !(snapshot.data!['userOrders'] is List)) {
            return const Center(child: Text('No orders found'));
          }

          // Safely extract and type-cast the orders list
          final userData = snapshot.data!;
          List<dynamic> ordersList = [];

          try {
            ordersList = List.from(userData['userOrders']);
          } catch (e) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Invalid orders data format'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Retry loading
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return OrderTapBar(userOrders: ordersList);
        },
      ),
    );
  }
}
