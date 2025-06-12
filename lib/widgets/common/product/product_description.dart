import 'package:flutter/material.dart';

class ProductDesc extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDesc({super.key, required this.product});

  @override
  State<ProductDesc> createState() => _ProductDescState();
}

class _ProductDescState extends State<ProductDesc> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String description = widget.product['description'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
          secondChild: Text(description, style: const TextStyle(fontSize: 14)),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        if (description.length > 100)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                isExpanded ? 'Show less' : 'Show more',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
