import 'package:flutter/material.dart';
import 'package:omeg_bazaar/services/get_category_api.dart';
import 'package:omeg_bazaar/services/get_product_by_category.dart';
import 'package:omeg_bazaar/widgets/common/category/category_btn.dart';
import 'package:omeg_bazaar/widgets/common/loaders/category_shimmer_loader.dart';
import 'package:omeg_bazaar/screens/home/widgets/products.dart';

class CategoryProduct extends StatefulWidget {
  const CategoryProduct({super.key});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct>
    with AutomaticKeepAliveClientMixin {
  List categories = [];
  List selectedProducts = [];
  String selectedCategory = '';
  bool isLoading = true;
  bool isProductsLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> fetchCategories() async {
    try {
      final data = await GetCategoryApiCall().get();
      setState(() {
        categories = data;
        isLoading = false;

        if (categories.isNotEmpty) {
          selectedCategory = categories[0]['name'];
          fetchProductsByCategory(selectedCategory);
        }
      });
    } catch (e) {
      // print('Category fetch error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchProductsByCategory(String categoryName) async {
    setState(() {
      isProductsLoading = true;
    });

    try {
      final data = await GetProdByCategory().getProductsByCategory(
        categoryName,
      );
      setState(() {
        selectedProducts = data;
      });
    } catch (e) {
      // print('Product fetch error: $e');
    } finally {
      setState(() {
        isProductsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoading
            ? const CategoryShimmerLoader()
            : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children:
                    categories.map((cat) {
                      final name = cat['name'] ?? 'Unnamed';
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CategoryButton(
                          label: name,
                          isSelected: name == selectedCategory,
                          onTap: () {
                            setState(() {
                              selectedCategory = name;
                            });
                            fetchProductsByCategory(name);
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
        const SizedBox(height: 16),
        Products(products: selectedProducts, isLoading: isProductsLoading),
      ],
    );
  }
}
