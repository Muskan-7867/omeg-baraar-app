import 'package:flutter/material.dart';

class CartButton extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartButton({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Decrement button
        Material(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            onTap: onDecrement,
            borderRadius: BorderRadius.circular(5),
            splashColor: Colors.red.withValues(alpha: 0.2),
            child: Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              child: Icon(Icons.remove, size: 16, color: Colors.red[500]),
            ),
          ),
        ),

        // Quantity display
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('$quantity', style: const TextStyle(fontSize: 16)),
        ),

        // Increment button
        Material(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            onTap: onIncrement,
            borderRadius: BorderRadius.circular(5),
            splashColor: Colors.red.withValues(alpha: 0.2),
            child: Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              child: Icon(Icons.add, size: 16, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
