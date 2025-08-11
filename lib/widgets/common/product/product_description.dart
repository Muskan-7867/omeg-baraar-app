import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class ProductDesc extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDesc({super.key, required this.product});

  @override
  State<ProductDesc> createState() => _ProductDescState();
}

class _ProductDescState extends State<ProductDesc> {
  bool isExpanded = false;
  bool needsExpansion = false;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextOverflow();
    });
  }

  void _checkTextOverflow() {
    final RenderBox? renderBox =
        _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: widget.product['description'] ?? '',
          style: const TextStyle(fontSize: 14),
        ),
        maxLines: 3,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: renderBox.size.width);
      setState(() {
        needsExpansion = textPainter.didExceedMaxLines;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String description = widget.product['description'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            description,
            key: _textKey,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
          secondChild: Text(description, style: const TextStyle(fontSize: 14)),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        if (needsExpansion)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  isExpanded ? 'Show less' : 'Show more',
                  style: TextStyle(fontSize: 14, color: AppColour.primaryColor),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
