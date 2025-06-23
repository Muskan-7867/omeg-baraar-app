import 'package:flutter/material.dart';

class FilterActionButtons extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onApply;
  final Color? buttonColor;
  final Color? textColor;

  const FilterActionButtons({
    super.key,
    required this.onReset,
    required this.onApply,
    this.buttonColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor ?? Colors.grey[200],
              foregroundColor: textColor ?? Colors.black,
            ),
            onPressed: onReset,
            child: const Text('Reset'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor ?? Colors.blue,
              foregroundColor: textColor ?? Colors.white,
            ),
            onPressed: onApply,
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
