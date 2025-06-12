import 'package:flutter/material.dart';
import 'package:omeg_bazaar/services/cart_helper.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:omeg_bazaar/widgets/common/product/product_detailimage.dart';
import 'package:omeg_bazaar/screens/product/widget/product_info_screen.dart';

class SingleProduct extends StatefulWidget {
  const SingleProduct({super.key});

  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  Map<String, dynamic>? product;
  bool isInCart = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (product == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        product = args;
        checkIfInCart();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
        });
      }
    }
  }

  Future<void> checkIfInCart() async {
    final prodId = product!['_id'].toString();
    final exists = await CartHelper.isInCart(prodId);
    setState(() {
      isInCart = exists;
    });
  }

  Future<void> toggleCart() async {
    final prodId = product!['_id'].toString();

    if (isInCart) {
      await CartHelper.removeFromCart(prodId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Removed from Cart')));
    } else {
      await CartHelper.addToCart(prodId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Added to Cart')));
    }

    setState(() {
      isInCart = !isInCart;
    });
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
          onPressed: () => Navigator.pop(context),
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
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: toggleCart,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          AppColour.primaryColor,
                        ),
                      ),
                      child: Text(
                        isInCart ? 'Remove from Cart' : 'Add to Cart',
                        style: TextStyle(color: AppColour.secondaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
