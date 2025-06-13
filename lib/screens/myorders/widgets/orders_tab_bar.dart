import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/myorders/widgets/single_order_card.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class OrderTapBar extends StatefulWidget {
  const OrderTapBar({super.key});

  @override
  State<OrderTapBar> createState() => _OrderTapBarState();
}

class _OrderTapBarState extends State<OrderTapBar>
    with TickerProviderStateMixin {
  final List<String> tabs = ['All', 'Completed', 'Delivered'];

  // Sample data for demonstration
  final List<Map<String, dynamic>> allOrders = [
    {
      'imageUrl':
          'https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg',
      'title': 'Brown Jacket',
      'size': 'XL',
      'quantity': 10,
      'price': 83.97,
    },
  ];

  final List<Map<String, dynamic>> completedOrders = [
    {
      'imageUrl':
          'https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg',
      'title': 'Brown Jackettt',
      'size': 'L',
      'quantity': 1,
      'price': 75.50,
    },
  ];

  final List<Map<String, dynamic>> deliveredOrders = [
    {
      'imageUrl':
          'https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg',
      'title': 'Brown Jacket',
      'size': 'M',
      'quantity': 2,
      'price': 90.00,
    },
  ];

  Widget _buildOrderList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('No orders found'));
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderProductCard(
          imageUrl: order['imageUrl'],
          title: order['title'],
          size: order['size'],
          quantity: order['quantity'],
          price: order['price'],
          // onTrackOrder: () {
          //   // Handle track order
          // },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              indicatorColor: AppColour.primaryColor,
              labelColor: AppColour.primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: tabs.map((text) => Tab(text: text)).toList(),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOrderList(allOrders),
                  _buildOrderList(completedOrders),
                  _buildOrderList(deliveredOrders),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
