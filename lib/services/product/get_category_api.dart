import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omeg_bazaar/utills/api_constants.dart';

class GetCategoryApiCall {
  static const String baseUrl = ApiConstants.baseUrl;

  Future<List> get() async {
    final uri = Uri.parse("$baseUrl/product/categories");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Access categories from the map
      final categories = data['categories'];

      if (categories is List) {
        return categories;
      } else {
        throw Exception("Unexpected format: 'categories' is not a List");
      }
    } else {
      throw Exception("Failed to load data");
    }
  }
}
