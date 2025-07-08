import 'package:flutter/material.dart';

class SecondParagraph extends StatelessWidget {
  final List<TextSpan> spans;
  const SecondParagraph(this.spans, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
          children: spans,
        ),
      ),
    );
  }
}
