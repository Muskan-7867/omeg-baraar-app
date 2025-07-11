
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omeg_bazaar/utills/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  static const baseUrl = ApiConstants.baseUrl;

  static Future<Map<String, dynamic>> getProductById(String singleproductid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      final response = await http.get(
        Uri.parse("$baseUrl/product/single/$singleproductid"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      throw Exception('Error fetching product details: $e');
    }
  }
}