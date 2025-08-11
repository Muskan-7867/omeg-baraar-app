import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/provider/cart_provider.dart';
import 'package:omeg_bazaar/screens/checkout/checkout.dart';
import 'package:omeg_bazaar/screens/product/widget/related_products_section.dart';
import 'package:omeg_bazaar/services/cart/cart_helper.dart';
import 'package:omeg_bazaar/services/product/get_related_products_api.dart';
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
  List<dynamic> relatedProducts = [];
  bool isLoadingRelated = false;
  final RelatedProductsService _relatedProductsService =
      RelatedProductsService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAuthToken();

    if (product == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        product = args;
        checkIfInCart();
        _fetchRelatedProducts();
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

  Future<void> _fetchRelatedProducts() async {
    if (product == null || product!['category'] == null) return;

    setState(() => isLoadingRelated = true);

    try {
      final categoryId = product!['category']['_id'] ?? product!['category'];
      final products = await _relatedProductsService.fetchRelatedProducts(
        categoryId.toString(),
        product!['_id'].toString(),
      );
      setState(() {
        relatedProducts = products;
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load related products',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => isLoadingRelated = false);
    }
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
          '',
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

  // Inside _SingleProductState
  void _handleProductTap(dynamic tappedProduct) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SingleProduct(
              cartProducts: widget.cartProducts,
              quantities: widget.quantities,
            ),
        settings: RouteSettings(arguments: tappedProduct),
      ),
    );
  }

  void buyNow() {
    if (product == null) return;

    if (authToken == null || authToken!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login to buy now')));
      Get.offNamed('/login');
      return;
    }

    final singleProductList = [product!];
    final quantities = [1];

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

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

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
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 10 : 20,
                horizontal: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: toggleCart,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          AppColour.secondaryColor,
                        ),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 16 : 20,
                          ),
                        ),
                      ),
                      child: Text(
                        isInCart ? 'Remove from Cart' : 'Add to Cart',
                        style: TextStyle(
                          color: AppColour.primaryColor,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 10 : 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: buyNow,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          AppColour.primaryColor,
                        ),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 16 : 20,
                          ),
                        ),
                      ),
                      child: Text(
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Related Products Section
            if (isLoadingRelated)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              RelatedProducts(
                products: relatedProducts,
                isSmallScreen: isSmallScreen,
                onProductTap: _handleProductTap,
              ),
            SizedBox(height: isSmallScreen ? 40 : 60),
          ],
        ),
      ),
    );
  }
}
