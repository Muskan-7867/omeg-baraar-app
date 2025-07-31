import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omeg_bazaar/utills/api_constants.dart';

class CodOrderApi {
  static Future<Map<String, dynamic>> createCodOrder({
    required List<dynamic> cartProducts,
    required List<int> quantities,
    required Map<String, dynamic> orderData,
    required String token,
    bool isBuyNow = false,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/order/create');

      // Prepare order items
      final orderItems =
          isBuyNow
              ? [
                {
                  'product': cartProducts[0]['_id'],
                  'quantity': quantities[0],
                  'price': cartProducts[0]['price'],
                },
              ]
              : List.generate(cartProducts.length, (index) {
                return {
                  'product': cartProducts[index]['_id'],
                  'quantity': quantities[index],
                  'price': cartProducts[index]['price'],
                };
              });

      // Calculate totals
      double totalPrice = 0;
      int totalQuantity = 0;

      for (int i = 0; i < cartProducts.length; i++) {
        totalPrice += cartProducts[i]['price'] * quantities[i];
        totalQuantity += quantities[i];
      }

      // Add delivery charges if needed
      const deliveryCharges = 0.0; // Adjust as needed

      final body = {
        ...orderData,
        'orderItems': orderItems,
        'totalPrice': totalPrice,
        'totalQuantity': totalQuantity,
        'deliveryCharges': deliveryCharges,
        'isBuyNow': isBuyNow,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'order': responseData['order']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create COD order',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
