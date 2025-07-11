import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omegbazaar/provider/cart_provider.dart';
import 'package:omegbazaar/screens/cart/widgets/checkout_btn.dart';
import 'package:omegbazaar/screens/cart/widgets/slidable_part.dart';
import 'package:omegbazaar/services/cart/cart_data_load.dart';
import 'package:omegbazaar/widgets/common/loaders/single_product_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleCartProduct extends StatefulWidget {
  const SingleCartProduct({super.key});

  @override
  State<SingleCartProduct> createState() => _SingleCartProductState();
}

class _SingleCartProductState extends State<SingleCartProduct> {
  List<Map<String, dynamic>> cartProducts = [];
  List<int> quantities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize the cart count when the page loads
      Provider.of<CartProvider>(context, listen: false).loadCartCount();
    });
    loadCartData();
  }

  Future<void> loadCartData() async {
    try {
      final (products, loadedQuantities) = await CartDataLoader.load();
      setState(() {
        cartProducts = List<Map<String, dynamic>>.from(products);
        quantities = List<int>.from(loadedQuantities);
      });
    } catch (e) {
      // You can log or show an error message here
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void increment(int index) {
    setState(() {
      quantities[index]++;
      _saveQuantity(index, quantities[index]);
    });
  }

  void decrement(int index) {
    if (quantities[index] > 1) {
      setState(() {
        quantities[index]--;
        _saveQuantity(index, quantities[index]);
      });
    }
  }

  Future<void> _saveQuantity(int index, int newQuantity) async {
    final prodId = cartProducts[index]['id'].toString();
    final prefs = await SharedPreferences.getInstance();
    final quantitiesMap = Map<String, int>.from(
      prefs.getString('cartQuantities') != null
          ? Map<String, int>.from(
            jsonDecode(prefs.getString('cartQuantities')!),
          )
          : {},
    );

    quantitiesMap[prodId] = newQuantity;
    await prefs.setString('cartQuantities', jsonEncode(quantitiesMap));
  }

  Future<void> removeItem(int index) async {
    final prodId = cartProducts[index]['id'].toString();
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('cartProdIds') ?? [];
    ids.remove(prodId);
    await prefs.setStringList('cartProdIds', ids);

    final quantitiesMap = Map<String, int>.from(
      prefs.getString('cartQuantities') != null
          ? Map<String, int>.from(
            jsonDecode(prefs.getString('cartQuantities')!),
          )
          : {},
    );
    quantitiesMap.remove(prodId);
    await prefs.setString('cartQuantities', jsonEncode(quantitiesMap));
    Provider.of<CartProvider>(context, listen: false).decrement();

    setState(() {
      cartProducts.removeAt(index);
      quantities.removeAt(index);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Item removed from cart')));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SingleCartProdCardShimmer();
    }

    if (cartProducts.isEmpty) {
      return const Center(child: Text("No products in cart"));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cartProducts.length,
            itemBuilder: (context, index) {
              final product = cartProducts[index];
              final imageUrl =
                  (product['images'] as List?)?.isNotEmpty == true
                      ? product['images'][0]['url']
                      : null;

              return CartProductSlidableItem(
                product: product,
                imageUrl: imageUrl,
                quantity: quantities[index],
                onIncrement: () => increment(index),
                onDecrement: () => decrement(index),
                onRemove: () => removeItem(index),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        CheckoutBtn(cartProducts: cartProducts, quantities: quantities),
        const SizedBox(height: 40),
      ],
    );
  }
}
