import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = "https://omeg-bazaar-backend.onrender.com/api/v1"; 

  Future<List<Map<String, dynamic>>> fetchProducts({
    int limit = 10,
    int page = 1,
    String? category,
    String? search,
  }) async {
    final uri = Uri.parse('$baseUrl/product/getquery').replace(
      queryParameters: {
        'limit': limit.toString(),
        'page': page.toString(),
        if (category != null && category != 'all') 'category': category,
        if (search != null && search.trim().isNotEmpty) 'search': search,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['products']);
    } else {
      throw Exception('Failed to load products');
    }
  }
}