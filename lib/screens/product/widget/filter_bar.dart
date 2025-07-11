import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/product/widget/category_section.dart';
import 'package:omeg_bazaar/screens/product/widget/filter_action_btn.dart';
import 'package:omeg_bazaar/screens/product/widget/price_slider.dart';
import 'package:omeg_bazaar/services/product/get_category_api.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class FilterBar extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBar({super.key, required this.onApplyFilters});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  List categories = [];
  bool isCategoryLoading = true;
  String? _selectedCategoryId;
  RangeValues _priceRange = const RangeValues(0, 1000);

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final data = await GetCategoryApiCall().get();
      setState(() {
        categories = data;
        isCategoryLoading = false;
      });
    } catch (e) {
      setState(() => isCategoryLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColour.primaryColor),
            child: const Center(
              child: Text(
                ' Filter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 58,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Use the new CategorySection widget
          CategorySection(
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: (newId) {
              setState(() {
                _selectedCategoryId = newId;
              });
            },
            categories: categories,
            isLoading: isCategoryLoading,
          ),

          const SizedBox(height: 20),
          const Divider(),

          // Price Range Section
          Column(
            children: [
              const ListTile(
                title: Text(
                  'Price Range',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              PriceSlider(
                currentRange: _priceRange,
                onRangeChanged: (newRange) {
                  setState(() => _priceRange = newRange);
                },
              ),
            ],
          ),

          FilterActionButtons(
            onReset: () {
              setState(() {
                _selectedCategoryId = null;
                _priceRange = const RangeValues(0, 1000);
              });
            },
            onApply: () {
              widget.onApplyFilters({
                'category': _selectedCategoryId,
                'minPrice': _priceRange.start,
                'maxPrice': _priceRange.end,
              });
              Navigator.pop(context);
            },
            buttonColor: AppColour.primaryColor,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
