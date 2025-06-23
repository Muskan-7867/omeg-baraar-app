import 'dart:convert';
import 'package:http/http.dart' as http;

class GetFilteredProducts {
  static const String baseUrl = "https://omeg-bazaar-backend.onrender.com/api/v1";

  Future<List<Map<String, dynamic>>> fetchFilteredProducts({
    int limit = 10,
    int page = 1,
    String? category,
    String? search,
    double minPrice = 0,
    double maxPrice = 1000000000000,
  }) async {
    final uri = Uri.parse('$baseUrl/product/getquery').replace(
      queryParameters: {
        'limit': limit.toString(),
        'page': page.toString(),
        'minPrice': minPrice.toString(),
        'maxPrice': maxPrice.toString(),
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