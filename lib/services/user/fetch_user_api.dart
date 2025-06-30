import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omeg_bazaar/utills/api.constraints.dart';

class UserService {
   static const baseUrl = ApiConstants.baseUrl;

  static Future<Map<String, dynamic>> getUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/user/current"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  static Future<List<dynamic>> getUserOrders(String token) async {
    try {
      final userResponse = await http.get(
        Uri.parse("$baseUrl/user/current"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // print('User response status: ${userResponse.statusCode}');
      // print('User response body: ${userResponse.body}');

      if (userResponse.statusCode == 200) {
        final userData = json.decode(userResponse.body);
        final List<dynamic> orderIds = userData['orders'] ?? [];
        // print('Found ${orderIds.length} order IDs');

        List<dynamic> orders = [];
        for (var orderId in orderIds) {
          try {
            final orderResponse = await http.get(
              Uri.parse("$baseUrl/order/single/$orderId"),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
            );

            // print(
            //   'Order $orderId response status: ${orderResponse.statusCode}',
            // );
            // print('Order $orderId response body: ${orderResponse.body}');

            if (orderResponse.statusCode == 200) {
              orders.add(json.decode(orderResponse.body));
            } else {
              // print(
              //   'Failed to fetch order $orderId: ${orderResponse.statusCode}',
              // );
            }
          } catch (e) {
            // print('Error fetching order $orderId: $e');
          }
        }

        return orders;
      } else {
        throw Exception('Failed to load user data: ${userResponse.statusCode}');
      }
    } catch (e) {
      // print('Error in getUserOrders: $e');
      throw Exception('Error fetching user orders: $e');
    }
  }
}
