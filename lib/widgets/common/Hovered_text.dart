import 'package:flutter/material.dart';

class HoverText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  final VoidCallback? onTap;

  const HoverText({
    super.key,
    required this.text,
    this.fontSize = 58,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.bold,
    this.onTap,
  });

  @override
  State<HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: isHovered ? 1.1 : 1.0,
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.textColor,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              shadows:
                  isHovered
                      ? [
                        const Shadow(
                          color: Colors.black54,
                          blurRadius: 8,
                          offset: Offset(2, 2),
                        ),
                      ]
                      : [],
            ),
          ),
        ),
      ),
    );
  }
}
