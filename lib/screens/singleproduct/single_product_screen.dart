import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/provider/cart_provider.dart';
import 'package:omeg_bazaar/screens/checkout/checkout.dart';
import 'package:omeg_bazaar/services/cart/cart_helper.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:omeg_bazaar/widgets/common/product/product_detailimage.dart';
import 'package:omeg_bazaar/screens/product/widget/product_info_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleProduct extends StatefulWidget {
  final List<Map<String, dynamic>> cartProducts;
  final List<int> quantities;

  const SingleProduct({
    super.key,
    required this.cartProducts,
    required this.quantities,
  });

  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  Map<String, dynamic>? product;
  bool isInCart = false;
  String? authToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAuthToken();

    if (product == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        product = args;
        checkIfInCart();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.back();
        });
      }
    }
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      authToken = prefs.getString('authToken');
    });
  }

  Future<void> checkIfInCart() async {
    final prodId = product!['_id'].toString();
    final exists = await CartHelper.isInCart(prodId);
    setState(() {
      isInCart = exists;
    });
  }

  Future<void> toggleCart({bool suppressSnackbar = false}) async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final prodId = product!['_id'].toString();

    if (isInCart) {
      await CartHelper.removeFromCart(prodId);
      cart.decrement();
      if (!suppressSnackbar) {
        Get.snackbar(
          '', // Empty title for cleaner look
          'Removed from Cart',
          colorText: Colors.white,
          backgroundColor: Colors.grey[850]!,
          snackPosition: SnackPosition.BOTTOM,
          duration: 2.seconds,
          margin: const EdgeInsets.all(16),
        );
      }
    } else {
      cart.increment();
      await CartHelper.addToCart(prodId);
      if (!suppressSnackbar) {
        Get.snackbar(
          '',
          'Added to Cart',
          colorText: Colors.white,
          backgroundColor: Colors.grey[850]!,
          snackPosition: SnackPosition.BOTTOM,
          duration: 2.seconds,
          margin: const EdgeInsets.all(16),
        );
      }
    }

    setState(() {
      isInCart = !isInCart;
    });
  }

  void buyNow() {
    if (product == null) return;

    // Check if user is logged in
    if (authToken == null || authToken!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login to buy now')));
      Get.offNamed('/login');
      return;
    }

    // Create a temporary list with just this product
    final singleProductList = [product!];
    final quantities = [1]; // Default quantity is 1

    // First add to cart if not already there
    if (!isInCart) {
      toggleCart(suppressSnackbar: true).then((_) {
        if (mounted) {
          _navigateToCheckout(singleProductList, quantities);
        }
      });
    } else {
      _navigateToCheckout(singleProductList, quantities);
    }
  }

  void _navigateToCheckout(
    List<Map<String, dynamic>> products,
    List<int> quantities,
  ) {
    Get.to(() => Checkout(cartProducts: products, quantities: quantities));
    checkIfInCart();
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final imageMaps = product!['images'] as List<dynamic>? ?? [];
    final imageUrls =
        imageMaps
            .where((img) => img is Map && img['url'] != null)
            .map((img) => img['url'] as String)
            .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductDetailImage(images: imageUrls),
            ProductInfoScreen(product: product!),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Add to Cart Button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: toggleCart,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          AppColour.secondaryColor,
                        ),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      child: Text(
                        isInCart ? 'Remove from Cart' : 'Add to Cart',
                        style: TextStyle(color: AppColour.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Buy Now Button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: buyNow,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          AppColour.primaryColor,
                        ),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
