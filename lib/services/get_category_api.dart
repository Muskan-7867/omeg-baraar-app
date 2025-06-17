import 'dart:convert';
import 'package:http/http.dart' as http;

class GetCategoryApiCall {
  static const String baseUrl =
      "https://omeg-bazaar-backend.onrender.com/api/v1";

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
