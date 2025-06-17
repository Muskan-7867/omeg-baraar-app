
import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    if (_count > 0) _count--;
    notifyListeners();
  }

  void setCount(int value) {
    _count = value;
    notifyListeners();
  }
}