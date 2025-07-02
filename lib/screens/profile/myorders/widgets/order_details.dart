import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class OrderDetails extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;
  final String paymentStatus;
  final double totalPrice;
  final bool isLoading;
  final String orderId;

  const OrderDetails({
    super.key,
    required this.orderItems,
    required this.paymentStatus,
    required this.totalPrice,
    required this.isLoading,
    required this.orderId,
  });

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isLoadingDetails = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  "#${widget.orderId.substring(widget.orderId.length - 6)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ListView.builder(
                itemCount: widget.orderItems.length,
                itemBuilder: (context, index) {
                  final item = widget.orderItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['productName'],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          Center(
            child: TextButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                  BorderSide(color: AppColour.primaryColor),
                ),
              ),
              onPressed: () {},
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }
}
