import 'package:flutter/material.dart';
import 'package:omegbazaar/widgets/common/category/category_btn.dart';
import 'package:omegbazaar/widgets/common/loaders/category_shimmer_loader.dart';

class CategoriesOnHomePage extends StatelessWidget {
  final List categories;
  final bool isCategoryLoading;
  final String selectedCategoryId; // Changed to ID
  final Function(String) onCategoryTap; // Expects ID

  const CategoriesOnHomePage({
    super.key,
    required this.categories,
    required this.isCategoryLoading,
    required this.selectedCategoryId, // Changed to ID
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        isCategoryLoading
            ? const CategoryShimmerLoader()
            : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((cat) {
                      final id = cat['_id'] ?? ''; // Get ID
                      final name = cat['name'] ?? 'Unnamed';
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: CategoryButton(
                          label: name,
                          isSelected: id == selectedCategoryId, // Compare IDs
                          onTap: () => onCategoryTap(id), // Pass ID
                        ),
                      );
                    }).toList(),
              ),
            ),
      ],
    );
  }
}
