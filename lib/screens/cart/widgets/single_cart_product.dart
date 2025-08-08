import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/provider/cart_provider.dart';
import 'package:omeg_bazaar/screens/cart/widgets/checkout_btn.dart';
import 'package:omeg_bazaar/screens/cart/widgets/slidable_part.dart';
import 'package:omeg_bazaar/services/cart/cart_data_load.dart';
import 'package:omeg_bazaar/widgets/common/loaders/single_product_shimmer.dart';
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
      _loadCartDataAndUpdateCount();
    });
  }

  Future<void> _loadCartDataAndUpdateCount() async {
    setState(() {
      isLoading = true;
      cartProducts.clear();
      quantities.clear();
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final cartIds = prefs.getStringList('cartProdIds') ?? [];

      final (products, loadedQuantities) = await CartDataLoader.load();

      // Filter products to only include those in cartIds
      final validProducts =
          products
              .where((product) => cartIds.contains(product['_id'].toString()))
              .toList();
      final validQuantities =
          loadedQuantities
              .asMap()
              .entries
              .where(
                (entry) =>
                    cartIds.contains(products[entry.key]['_id'].toString()),
              )
              .map((entry) => entry.value)
              .toList();

      setState(() {
        cartProducts = List<Map<String, dynamic>>.from(validProducts);
        quantities = List<int>.from(validQuantities);
        isLoading = false;
      });

      // Update CartProvider count
      Provider.of<CartProvider>(
        context,
        listen: false,
      ).setCount(cartIds.length);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load cart data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
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
    final prodId = cartProducts[index]['_id'].toString();
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
    final prodId = cartProducts[index]['_id'].toString();
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('cartProdIds') ?? [];
    ids.remove(prodId);
    await prefs.setStringList('cartProdIds', ids);
    // print('Cart IDs after removal: $ids');

    final quantitiesMap = Map<String, int>.from(
      prefs.getString('cartQuantities') != null
          ? Map<String, int>.from(
            jsonDecode(prefs.getString('cartQuantities')!),
          )
          : {},
    );
    quantitiesMap.remove(prodId);
    await prefs.setString('cartQuantities', jsonEncode(quantitiesMap));

    setState(() {
      cartProducts.removeAt(index);
      quantities.removeAt(index);
    });

    // Update CartProvider count and notify listeners
    Provider.of<CartProvider>(context, listen: false).setCount(ids.length);

    Get.snackbar(
      '',
      'Item removed from cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[800]!,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('Cart products to display: $cartProducts');
    if (isLoading) {
      return const SingleCartProdCardShimmer();
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
