import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/screens/trackorder/order_track.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class OrderProductCard extends StatelessWidget {
  final String orderId;
  final String imageUrl;
  final String title;
  final String status;
  final int quantity;
  final double price;
  final String expectedDeliveryDate;
  final String paymentMethod;

  const OrderProductCard({
    super.key,
    required this.orderId,
    required this.imageUrl,
    required this.title,
    required this.status,
    required this.quantity,
    required this.price,
    required this.expectedDeliveryDate,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty : $quantity',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rs ${price.toStringAsFixed(2)} /-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  Text(
                    ' $status',
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(
                  () => OrderTrack(
                    orderId: orderId,
                    productImage: imageUrl,
                    productTitle: title,
                    productPrice: price,
                    quantity: quantity,
                    status: status,
                    expectedDeliveryDate: expectedDeliveryDate,
                    paymentMethod: paymentMethod,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColour.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Track Order',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
