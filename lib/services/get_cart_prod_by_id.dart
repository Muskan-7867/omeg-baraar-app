import 'dart:convert';
import 'package:http/http.dart' as http;

//http://10.0.2.2:3000
class GetCartProdById {
  static const String baseUrl =
      "https://omeg-bazaar-backend.onrender.com/api/v1";

  Future<List> get(List<String> ids) async {
    final uri = Uri.parse("$baseUrl/product/cartproducts");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"ids": ids}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final products = data['products'];

      if (products is List) {
        return products;
      } else {
        throw Exception("Unexpected format: 'products' is not a List");
      }
    } else {
      throw Exception("Failed to load cart products: ${response.statusCode}");
    }
  }
}
