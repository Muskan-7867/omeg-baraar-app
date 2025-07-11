import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omegbazaar/utills/api_constants.dart';

class GetProductsApiCall {
  static const String baseUrl =  ApiConstants.baseUrl;

 Future<List<Map<String, dynamic>>> getProducts() async {
  final uri = Uri.parse("$baseUrl/product/all");
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final products = data['products'];

    if (products is List) {
      // ✅ Explicitly cast each item in the list
      return products.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception("Unexpected format: 'products' is not a List");
    }
  } else {
    throw Exception("Failed to load data");
  }
}

}
