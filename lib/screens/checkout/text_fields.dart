import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;
  final bool isRequired;
  final Color? borderColor; // Add this parameter for custom border color

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.isRequired = true,
    this.borderColor, // Add this to constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color:
                borderColor ??
                Theme.of(
                  context,
                ).primaryColor, // Use custom color or theme primary
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color:
                borderColor ??
                Theme.of(
                  context,
                ).primaryColor, // Use custom color or theme primary
            width: 2.0, // You can adjust the width for focused state
          ),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator ?? (isRequired ? _defaultValidator : null),
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter $labelText';
    }
    return null;
  }
}
