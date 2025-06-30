import 'package:shared_preferences/shared_preferences.dart';
import 'get_cart_prod_by_id.dart';

class CartDataLoader {
  static Future<(List<dynamic> products, List<int> quantities)> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedProdIds = prefs.getStringList("cartProdIds") ?? [];

    final allProducts = await GetCartProdById().get(savedProdIds);

    final filtered =
        allProducts.where((product) {
          final id = product['_id'].toString();
          return savedProdIds.contains(id);
        }).toList();

    final quantities = List<int>.filled(filtered.length, 1);

    return (filtered, quantities);
  }
}
