import 'dart:async';

import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final bool isSmallScreen;
  const CustomSearchBar({super.key, required this.onSearch, required this.isSmallScreen});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TextEditingController _controller; // Declare controller
  final _debounceDuration = const Duration(milliseconds: 500); // Debounce delay
  Timer? _debounce; // For debouncing search

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(); // Initialize controller
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller
    _debounce?.cancel(); // Cancel any pending debounce
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancel previous debounce if it exists
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Start new debounce timer
    _debounce = Timer(_debounceDuration, () {
      widget.onSearch(query); // Call search callback after delay
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller, // Use the managed controller
      onChanged: _onSearchChanged, // Use the debounced callback
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(60),
        ),
        hintText: 'Search',
      ),
    );
  }
}
