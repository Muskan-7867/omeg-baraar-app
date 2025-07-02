import 'package:flutter/material.dart';

class OrderData extends StatefulWidget {
    final List<dynamic> cartProducts;
  final List<int> quantities;
  const OrderData({super.key, required this.cartProducts, required this.quantities});

  @override
  State<OrderData> createState() => _OrderDataState();
}

class _OrderDataState extends State<OrderData> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: ListView.builder(
              itemCount: widget.cartProducts.length,
              itemBuilder: (context, index) {
                final product = widget.cartProducts[index];
                final qty = widget.quantities[index];
                return ListTile(
                  leading: Image.network(
                    product['images'][0]['url'],
                    width: 50,
                    height: 50,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                  ),
                  title: Text(product['name']),
                  subtitle: Text('Rs. ${product['price'].toString()} /-'),
                  trailing: Text(qty.toString()),
                );
              },
            ),
          );
  }
}