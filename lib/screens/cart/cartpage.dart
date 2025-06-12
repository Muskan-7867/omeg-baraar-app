import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/cart/widgets/single_cart_product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart'), centerTitle: true),

      body: SingleCartProduct(),
     
    );
  }
}
