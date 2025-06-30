import 'package:flutter/material.dart';
import 'package:omeg_bazaar/provider/cart_provider.dart';
import 'package:omeg_bazaar/services/cart/cart_helper.dart';
import 'package:omeg_bazaar/widgets/common/product/product_info_and_cartbtn.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool inCart = false;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        (widget.product['images'] != null &&
                widget.product['images'].isNotEmpty)
            ? widget.product['images'][0]['url']
            : 'https://example.com/default.jpg';

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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.contain,
                  ),
                ),
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
