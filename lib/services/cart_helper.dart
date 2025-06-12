

import 'package:shared_preferences/shared_preferences.dart';

class CartHelper {
  static Future<List<String>> getCartIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('cartProdIds') ?? [];
  }

  static Future<bool> isInCart(String id) async {
    final ids = await getCartIds();
    return ids.contains(id);
  }

  static Future<void> addToCart(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('cartProdIds') ?? [];
    if (!ids.contains(id)) {
      ids.add(id);
      await prefs.setStringList('cartProdIds', ids);
    }
  }

  static Future<void> removeFromCart(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('cartProdIds') ?? [];
    ids.remove(id);
    await prefs.setStringList('cartProdIds', ids);
  }
}
