import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omeg_bazaar/utills/api.constants.dart';

//http://10.0.2.2:3000
class GetCartProdById {
 static const baseUrl = ApiConstants.baseUrl;

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
