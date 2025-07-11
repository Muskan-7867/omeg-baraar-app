
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omegbazaar/utills/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  static const baseUrl = ApiConstants.baseUrl;

  static Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      final response = await http.get(
        Uri.parse("$baseUrl/order/single/$orderId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load order details');
      }
    } catch (e) {
      throw Exception('Error fetching order details: $e');
    }
  }
}