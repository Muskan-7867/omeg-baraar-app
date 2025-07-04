import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/trackorder/widgets/order_timeline.dart';
import 'package:omeg_bazaar/screens/trackorder/widgets/tarck_order_card.dart';

class OrderTrack extends StatefulWidget {
  final String orderId;
  final String productImage;
  final String productTitle;
  final double productPrice;
  final int quantity;
  final String status;
  final String expectedDeliveryDate;

  const OrderTrack({
    super.key,
    required this.orderId,
    required this.productImage,
    required this.productTitle,
    required this.productPrice,
    required this.quantity,
    required this.status,
    required this.expectedDeliveryDate,
  });

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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrackOrderProductCard(
            imageUrl: widget.productImage,
            title: widget.productTitle,
            size: 'size', // You might want to add this to your parameters
            quantity: widget.quantity,
            price: widget.productPrice,
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Order Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Expected Delivery Date:'),
                    Text(widget.expectedDeliveryDate),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Tracking Id:'), Text(widget.orderId)],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Order Status:'),
                    Text(
                      widget.status,
                      style: TextStyle(
                        color: _getStatusColor(widget.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Order Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 500,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OrderTimeLine(
                // Pass status to timeline if needed
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
