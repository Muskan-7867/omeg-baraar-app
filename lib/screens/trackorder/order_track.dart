import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/screens/checkout/local_data_handler.dart';
import 'package:omeg_bazaar/screens/trackorder/widgets/order_timeline.dart';
import 'package:omeg_bazaar/screens/trackorder/widgets/tarck_order_card.dart';
import 'package:omeg_bazaar/services/order/cancel_order_api.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class OrderTrack extends StatefulWidget {
  final String orderId;
  final String productImage;
  final String productTitle;
  final double productPrice;
  final int quantity;
  final String status;
  final String expectedDeliveryDate;
  final String paymentMethod;

  const OrderTrack({
    super.key,
    required this.orderId,
    required this.productImage,
    required this.productTitle,
    required this.productPrice,
    required this.quantity,
    required this.status,
    required this.expectedDeliveryDate,
    required this.paymentMethod,
  });

  @override
  State<OrderTrack> createState() => _OrderTrackState();
}

class _OrderTrackState extends State<OrderTrack> {
  bool _isCancelling = false;
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.status;
  }

  Future<void> _cancelOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isCancelling = true);

    try {
      final userData = await LocalDataHandler.loadUserData();
      final authToken = userData['authToken'];

      if (authToken == null) {
        throw Exception('Authentication required');
      }

      final result = await OrderApi.cancelOrder(widget.orderId, authToken);
      print('Cancel Order Response: $result');

      if (result['success'] == true) {
        setState(() {
          _currentStatus = 'cancelled';
          _isCancelling = false;
        });

        Get.snackbar(
          'Success',
          result['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      setState(() => _isCancelling = false);
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrackOrderProductCard(
              imageUrl: widget.productImage,
              title: widget.productTitle,
              size: 'size',
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
                    children: [
                      const Text('Tracking Id:'),
                      Text(widget.orderId),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order Status:'),
                      Text(
                        _currentStatus,
                        style: TextStyle(
                          color: _getStatusColor(_currentStatus),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Payment Method:'),
                      Text(widget.paymentMethod),
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
              height: 400,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OrderTimeLine(status: _currentStatus),
              ),
            ),
            
            // Show cancel button only for pending/processing orders that aren't already cancelled
            if (_currentStatus.toLowerCase() == 'pending' ||
                _currentStatus.toLowerCase() == 'processing')
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 2,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColour.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    onPressed: _isCancelling ? null : _cancelOrder,
                    child: _isCancelling
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Cancel Order',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
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
