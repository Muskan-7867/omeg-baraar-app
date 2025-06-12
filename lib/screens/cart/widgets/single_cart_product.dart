import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/cart/widgets/checkout_btn.dart';
import 'package:omeg_bazaar/screens/cart/widgets/slidable_part.dart';
import 'package:omeg_bazaar/services/cart_data_load.dart';
import 'package:omeg_bazaar/widgets/common/loaders/single_product_shimmer.dart';
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
    });
  }

  void decrement(int index) {
    if (quantities[index] > 1) {
      setState(() {
        quantities[index]--;
      });
    }
  }

  Future<void> removeItem(int index) async {
    final prodId = cartProducts[index]['id'].toString();
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('cartProdIds') ?? [];
    ids.remove(prodId);
    await prefs.setStringList('cartProdIds', ids);

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
        CheckoutBtn(),
        const SizedBox(height: 40),
      ],
    );
  }
}
