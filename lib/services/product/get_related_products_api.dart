import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:omeg_bazaar/utills/api_constants.dart';

class RelatedProductsService {
  static const String baseUrl = ApiConstants.baseUrl;

  Future<List<dynamic>> fetchRelatedProducts(
    String categoryId, 
    String excludeProductId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/product/categoryid/$categoryId'),
        headers: {
          'Content-Type': 'application/json',
          // Add other headers if needed (like auth tokens)
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final allProducts = List.from(data['products'] ?? []);
        return allProducts.where((p) => p['_id'] != excludeProductId).toList();
      }
      throw Exception('Failed to load related products: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching related products: $e');
    }
  }
}