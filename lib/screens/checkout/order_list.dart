import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class OrderList extends StatefulWidget {
  final List<dynamic> cartProducts;
  final List<int> quantities;

  const OrderList({
    super.key,
    required this.cartProducts,
    required this.quantities,
  });

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Text(
            'Order List',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
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
                ),
                title: Text(product['name']),
                subtitle: Text('Rs. ${product['price'].toString()} /-'),
                trailing: Text(qty.toString()),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColour.primaryColor,
            ),
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Continue to Payment',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
