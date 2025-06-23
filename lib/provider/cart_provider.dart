import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  Future<void> loadCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = prefs.getStringList('cartProdIds') ?? [];
    _count = cartItems.length;
    notifyListeners();
  }

  Future<void> increment() async {
    _count++;
    notifyListeners();
  }

  Future<void> decrement() async {
    if (_count > 0) {
      _count--;
      notifyListeners();
    }
  }

  Future<void> setCount(int value) async {
    _count = value;
    notifyListeners();
  }

  Future<void> updateCountFromPrefs() async {
    await loadCartCount();
  }
}