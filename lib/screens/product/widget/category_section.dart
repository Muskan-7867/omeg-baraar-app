import 'package:flutter/material.dart';
import 'package:omeg_bazaar/widgets/common/category/category_btn.dart';
import 'package:omeg_bazaar/widgets/common/loaders/category_shimmer_loader.dart';

class CategorySection extends StatefulWidget {
  final String? selectedCategoryId;
  final Function(String?) onCategorySelected;
  final List categories;
  final bool isLoading;

  const CategorySection({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    required this.categories,
    required this.isLoading,
  });

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        widget.isLoading
            ? const CategoryShimmerLoader()
            : Container(
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 250),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  children:
                      widget.categories.map((cat) {
                        final id = cat['_id'] ?? '';
                        final name = cat['name'] ?? 'Unnamed';
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CategoryButton(
                            label: name,
                            isSelected: widget.selectedCategoryId == id,
                            onTap: () {
                              widget.onCategorySelected(
                                (widget.selectedCategoryId == id) ? null : id,
                              );
                            },
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
      ],
    );
  }
}
