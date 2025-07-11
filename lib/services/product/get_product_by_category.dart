import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omegbazaar/utills/api_constants.dart';

class GetProdByCategory {
  static const String baseUrl =  ApiConstants.baseUrl;

  Future<List> getProductsByCategory(String name) async {
    final uri = Uri.parse("$baseUrl/product/category/name/$name");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final categoryProducts = data['products'];

      if (categoryProducts is List) {
        return categoryProducts;
      } else {
        throw Exception("Failed to load categoryProducts");
      }
    } else {
      throw Exception("Failed to load categoryProducts");
    }
  }
}
