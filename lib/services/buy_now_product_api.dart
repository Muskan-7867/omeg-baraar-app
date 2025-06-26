import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BuyNowProductApi {
  static const String _baseUrl =
      "https://omeg-bazaar-backend.onrender.com/api/v1";

 static Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('authToken');
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> createRazorpayOrder({
    required String productId,
    required String address,
    required int quantity,
    required String paymentMethod,
  }) async {
    final url = Uri.parse('$_baseUrl/order/razorpayorder');
    final authToken = await _getAuthToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'productid': productId,
          'address': address,
          'quantity': quantity,
          'paymentMethod': paymentMethod,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create Razorpay order: $e');
    }
  }

  // Verify payment with backend
  static Future<bool> verifyPayment({
    required String orderId,
    required String razorpayOrderId,
    required String paymentId,
    required String razorpaySignature,
    required String paymentMethod,
  }) async {
    final url = Uri.parse('$_baseUrl/order/paymentverify');
    final authToken = await _getAuthToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'orderId': orderId,
          'razorpay_order_id': razorpayOrderId,
          'razorpay_payment_id': paymentId,
          'razorpay_signature': razorpaySignature,
          'paymentMethod': paymentMethod,
        }),
      );

      final responseData = json.decode(response.body);
      return responseData['success'] == true;
    } catch (e) {
      throw Exception('Failed to verify payment: $e');
    }
  }
}
