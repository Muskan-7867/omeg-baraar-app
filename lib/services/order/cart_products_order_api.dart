// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omegbazaar/utills/api_constants.dart';

class CartProductsOrderApi {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<Map<String, dynamic>> createRazorPayOrderOfCart({
    required List<String> cartProductIds,
    required Map<String, dynamic>? address,
    required List<int> quantities,
    required String paymentMethod,
    required String? token,
  }) async {
    final url = Uri.parse('$baseUrl/order/cartrazorpayorder');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'cartProductIds': cartProductIds,
        'address': address,
        'quantities': quantities,
        'paymentMethod': paymentMethod,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create Razorpay order');
    }
  }

  static Future<bool> verifyCartPayment({
    required String orderId,
    required String razorpayOrderId,
    required String paymentId,
    required String razorpaySignature,
    required String paymentMethod,
    required String? token,
  }) async {
    final url = Uri.parse('$baseUrl/order/paymentverify');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'orderId': orderId,
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': razorpaySignature,
        'paymentMethod': paymentMethod,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      throw Exception('Failed to verify payment: ${response.body}');
    }
  }
}
