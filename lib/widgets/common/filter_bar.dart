import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/product/widget/price_slider.dart';
import 'package:omeg_bazaar/services/get_category_api.dart';
import 'package:omeg_bazaar/widgets/common/category/category_btn.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:omeg_bazaar/widgets/common/loaders/category_shimmer_loader.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  List categories = [];
  String selectedCategory = '';
  bool isCategoryLoading = true;

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
      setState(() {
        isCategoryLoading = false;
      });
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

          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Categories',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          isCategoryLoading
              ? const CategoryShimmerLoader()
              : Container(
                constraints: BoxConstraints(minHeight: 50, maxHeight: 250),

                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    children:
                        categories.map((cat) {
                          final name = cat['name'] ?? 'Unnamed';
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: CategoryButton(
                              label: name,
                              isSelected: name == selectedCategory,
                              onTap: () {
                                setState(() {
                                  selectedCategory = name;
                                });
                                Navigator.of(context).pop(name);
                              },
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
          const SizedBox(height: 20),
          const Divider(),
          Column(
            children: [
              ListTile(
                title: const Text(
                  'Price Range',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              PriceSlider(),
            ],
          ),
          ],
      ),
    );
  }
}
