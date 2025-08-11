import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/provider/cart_provider.dart';
import 'package:omeg_bazaar/services/cart/cart_helper.dart';
import 'package:omeg_bazaar/widgets/common/product/product_info_and_cartbtn.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool? isSmallScreen;

  const ProductCard({super.key, required this.product,  this.isSmallScreen});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool inCart = false;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    checkCartStatus();
    
    Provider.of<CartProvider>(context, listen: false).addListener(_onCartChange);
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Remove listener to prevent memory leaks
    Provider.of<CartProvider>(context, listen: false).removeListener(_onCartChange);
    super.dispose();
  }

  void _onCartChange() {
    // Re-check cart status when CartProvider notifies changes
    checkCartStatus();
  }

  Future<void> checkCartStatus() async {
    final prodId = widget.product['_id'].toString();
    final result = await CartHelper.isInCart(prodId);
    setState(() {
      inCart = result;
    });
  }

  Future<void> toggleCart() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final prodId = widget.product['_id'].toString();

    if (inCart) {
      await CartHelper.removeFromCart(prodId);
      cart.decrement();
      Get.showSnackbar(
        GetSnackBar(
          message: 'Removed from cart',
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
          borderRadius: 4,
          backgroundColor: Colors.grey[800]!,
          animationDuration: const Duration(milliseconds: 300),
          isDismissible: true,
        ),
      );
    } else {
      await CartHelper.addToCart(prodId);
      cart.increment();
      Get.snackbar(
        'Cart Products',
        'Added to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey[850]!,
        colorText: Colors.white,
        borderRadius: 4.0,
        margin: const EdgeInsets.all(10),
      );
    }

    setState(() {
      inCart = !inCart;
    });
  }

  List<String> getImageUrls() {
    if (widget.product['images'] == null || widget.product['images'].isEmpty) {
      return ['https://example.com/default.jpg'];
    }
    return widget.product['images']
        .map<String>((img) => img['url'] as String)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrls = getImageUrls();

    return Card(
      color: Colors.transparent,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.toNamed('/singleproduct', arguments: widget.product);
            },
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: imageUrls.length,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(imageUrls[index]),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          ProductInfoAndCartbtn(
            product: widget.product,
            inCart: inCart,
            onToggleCart: toggleCart,
          ),
        ],
      ),
    );
  }
}