import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderApi {
  static const String baseUrl = "http://10.0.2.2:3000/api/v1";
  static Future<Map<String, dynamic>> cancelOrder(
  String orderId,
  String authToken,
) async {
  final url = Uri.parse('$baseUrl/order/cancel');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({'orderId': orderId}),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {
        'success': true,
        'message': responseData['message'] ?? 'Order cancelled successfully',
        'order': responseData['order'],
      };
    } else {
      return {
        'success': false,
        'message': responseData['message'] ?? 
          'Failed to cancel order (Status: ${response.statusCode})',
      };
    }
  } catch (e) {
    return {
      'success': false, 
      'message': 'Network error: ${e.toString()}'
    };
  }
}
}