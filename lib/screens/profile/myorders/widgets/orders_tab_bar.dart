import 'package:flutter/material.dart';
import 'package:omegbazaar/screens/profile/myorders/widgets/single_order_card.dart';
import 'package:omegbazaar/utills/app_colour.dart';
import 'package:omegbazaar/services/order/get_product_by_id.dart';

class OrderTapBar extends StatefulWidget {
  final List<dynamic> userOrders;
  const OrderTapBar({super.key, required this.userOrders});

  @override
  State<OrderTapBar> createState() => _OrderTapBarState();
}

class _OrderTapBarState extends State<OrderTapBar>
    with TickerProviderStateMixin {
  late List<dynamic> allOrders;
  late List<dynamic> processingOrders;
  late List<dynamic> deliveredOrders;
  final Map<String, dynamic> _productCache = {};
  final Set<String> _pendingFetches = {};

  final List<String> tabs = ['All', 'Processing', 'Delivered'];

  @override
  void initState() {
    super.initState();
    allOrders = widget.userOrders;
    _categorizeOrders();
    _prefetchProducts();
  }

  void _categorizeOrders() {
    processingOrders =
        allOrders.where((order) {
          final status = order['status']?.toString().toLowerCase();
          return status != 'delivered' &&
              status != 'completed'; // Changed logic
        }).toList();

    deliveredOrders =
        allOrders.where((order) {
          final status = order['status']?.toString().toLowerCase();
          return status == 'delivered' ||
              status == 'completed'; // Combined delivered and completed
        }).toList();
  }

  void _prefetchProducts() {
    for (final order in allOrders) {
      final items = order['orderItems'];
      if (items is List && items.isNotEmpty) {
        final productId = items[0]['product']?.toString();
        if (productId != null &&
            productId.isNotEmpty &&
            !_productCache.containsKey(productId) &&
            !_pendingFetches.contains(productId)) {
          _pendingFetches.add(productId);
          ProductService.getProductById(productId)
              .then((response) {
                if (response['success'] == true &&
                    response['product'] != null) {
                  if (mounted) {
                    setState(() {
                      _productCache[productId] = response['product'];
                      _pendingFetches.remove(productId);
                    });
                  }
                }
              })
              .catchError((_) {
                _pendingFetches.remove(productId);
              });
        }
      }
    }
  }

  String _parseImageUrl(dynamic images) {
    if (images is List && images.isNotEmpty) {
      final firstImage = images[0];
      if (firstImage is String) return firstImage;
      if (firstImage is Map) return firstImage['url']?.toString() ?? '';
    }
    return '';
  }

  Widget _buildOrderList(List<dynamic> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('No orders found'));
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final orderId = order['_id']?.toString() ?? 'N/A';
        final status = order['status']?.toString() ?? 'Pending';
        final itemCount = order['orderItems']?.length ?? 0;
        final price =
            (order['totalPrice'] is num)
                ? (order['totalPrice'] as num).toDouble()
                : 0.0;
   final expectedDeliveryDate = order['expectedDeliveryDate'] != null 
    ? DateTime.parse(order['expectedDeliveryDate'].toString()).toLocal().toString().split(' ')[0]
    : '';
      final paymentMethod = order['paymentMethod']?.toString() ?? 'N/A';
        // Get first product ID for preview
        String? firstProductId;
        dynamic productDetails;
        String title = 'Order #${orderId.substring(0, 6)}';
        String imageUrl = '';

        if (order['orderItems'] is List && order['orderItems'].isNotEmpty) {
          firstProductId = order['orderItems'][0]['product']?.toString();
          if (firstProductId != null &&
              _productCache.containsKey(firstProductId)) {
            productDetails = _productCache[firstProductId];
            title = productDetails['name'] ?? title;
            imageUrl = _parseImageUrl(productDetails['images']);
          }
        }

        return OrderProductCard(
          orderId: orderId,
          status: status,
          imageUrl: imageUrl,
          title: title,
          quantity: itemCount,
          price: price,
          expectedDeliveryDate: expectedDeliveryDate,
          paymentMethod: paymentMethod,
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
                  _buildOrderList(
                    processingOrders,
                  ), // Changed from completedOrders
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
