import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omeg_bazaar/utills/api_constants.dart';

class GetFilteredProducts {
  static const String baseUrl = ApiConstants.baseUrl;

  Future<List<Map<String, dynamic>>> fetchFilteredProducts({
    
    int page = 1,
    String? category,
    String? search,
    double minPrice = 0,
    double maxPrice = 1000000000000,
  }) async {
    final uri = Uri.parse('$baseUrl/product/getquery').replace(
      queryParameters: {
    
        'page': page.toString(),
        'minPrice': minPrice.toString(),
        'maxPrice': maxPrice.toString(),
        if (category != null && category.isNotEmpty) 'category': category,
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
