import 'package:flutter/material.dart';
import 'package:omegbazaar/provider/cart_provider.dart';
import 'package:omegbazaar/services/cart/cart_helper.dart';
import 'package:omegbazaar/widgets/common/product/product_info_and_cartbtn.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Removed from cart')));
    } else {
      await CartHelper.addToCart(prodId);

      cart.increment();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Added to cart')));
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
    final bool multipleImages = imageUrls.length > 1;

    return Card(
      color: Colors.transparent,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/singleproduct',
                arguments: widget.product,
              );
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
