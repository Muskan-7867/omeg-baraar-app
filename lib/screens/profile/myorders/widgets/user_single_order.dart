import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/profile/myorders/widgets/order_details.dart';
import 'package:omeg_bazaar/services/order/get_orders_by_id.dart';
import 'package:omeg_bazaar/services/order/get_product_by_id.dart';

class UserSingleOrder extends StatefulWidget {
  final dynamic order;
  const UserSingleOrder({super.key, required this.order});

  @override
  State<UserSingleOrder> createState() => _UserSingleOrderState();
}

class _UserSingleOrderState extends State<UserSingleOrder> {
  late dynamic order;
  bool isLoadingDetails = false;
  Map<String, dynamic>? orderDetails;
  final Map<String, dynamic> productDetailsCache = {};

  @override
  void initState() {
    super.initState();
    order = widget.order;
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    final orderId = order['_id']?.toString();
    if (orderId == null) return;

    setState(() => isLoadingDetails = true);
    try {
      final details = await OrderService.getOrderDetails(orderId);
      setState(() => orderDetails = details);

      // Pre-fetch all product details simultaneously
      final productIds = _getUniqueProductIds(details ?? order);
      await Future.wait(productIds.map(_fetchProductDetails));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading order details: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoadingDetails = false);
    }
  }

  Set<String> _getUniqueProductIds(dynamic orderData) {
    final Set<String> ids = {};
    final items = orderData['orderItems'];
    if (items is! List) return ids;

    for (final item in items) {
      final productId = item['product']?.toString();
      if (productId != null && productId.isNotEmpty) {
        ids.add(productId);
      }
    }
    return ids;
  }

  Future<void> _fetchProductDetails(String productId) async {
    if (productDetailsCache.containsKey(productId)) return;

    try {
      final response = await ProductService.getProductById(productId);
      if (response['success'] == true && response['product'] != null) {
        productDetailsCache[productId] = response['product'];
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading product: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayOrder = orderDetails ?? order;
    final orderId = displayOrder['_id']?.toString() ?? 'N/A';
    final totalPrice = _parseDouble(displayOrder['totalPrice']);
    final paymentStatus = _getPaymentStatus(displayOrder);

    return OrderDetails(
      orderItems: _buildOrderItems(displayOrder),
      paymentStatus: paymentStatus,
      totalPrice: totalPrice,
      isLoading: isLoadingDetails,
      orderId: orderId,
    );
  }

  List<Map<String, dynamic>> _buildOrderItems(dynamic displayOrder) {
    final items = displayOrder['orderItems'];
    if (items is! List) return [];

    return items.map<Map<String, dynamic>>((item) {
      final productId = item['product']?.toString() ?? '';
      final cachedProduct = productDetailsCache[productId];

      return {
        'productId': productId,
        'productName': cachedProduct?['name'] ?? 'Loading...',
        'imageUrl': _getFirstImage(cachedProduct),
        'quantity': _parseInt(item['quantity']),
        'price': _parseDouble(item['price']),
        'size': item['size']?.toString() ?? 'N/A',
        'orderId': displayOrder['_id']?.toString() ?? '',
      };
    }).toList();
  }

  String? _getFirstImage(dynamic product) {
    if (product is! Map || product['images'] is! List) return null;
    final images = product['images'][0]['url'] as List;
    return images.isNotEmpty ? images.first.toString() : null;
  }

  double _parseDouble(dynamic value) => (value is num) ? value.toDouble() : 0.0;
  int _parseInt(dynamic value) => (value is num) ? value.toInt() : 1;

  String _getPaymentStatus(dynamic orderData) {
    if (orderData['payment'] is Map) {
      return orderData['payment']['status']?.toString() ?? 'Pending';
    }
    return 'Pending';
  }
}
