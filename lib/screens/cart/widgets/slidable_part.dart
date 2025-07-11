import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:omegbazaar/screens/cart/widgets/single_cartprod_card.dart';

class CartProductSlidableItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final String? imageUrl;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartProductSlidableItem({
    super.key,
    required this.product,
    required this.imageUrl,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(product['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: onRemove),
        children: [
          SlidableAction(
            onPressed: (_) => onRemove(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: SingleCartProdCard(
        product: product,
        imageUrl: imageUrl,
        quantity: quantity,
        onIncrement: onIncrement,
        onDecrement: onDecrement,
      ),
    );
  }
}
