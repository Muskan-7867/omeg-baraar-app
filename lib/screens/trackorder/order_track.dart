import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/myorders/order.dart';
import 'package:omeg_bazaar/screens/trackorder/widgets/tarck_order_card.dart';

class OrderTrack extends StatefulWidget {
  const OrderTrack({super.key});

  @override
  State<OrderTrack> createState() => _OrderTrackState();
}

class _OrderTrackState extends State<OrderTrack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MyOrders()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrackOrderProductCard(
            imageUrl:
                'https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg',
            title: 'title',
            size: 'size',
            quantity: 1,
            price: 1000,
          ),

          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Text(
              'Order Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
