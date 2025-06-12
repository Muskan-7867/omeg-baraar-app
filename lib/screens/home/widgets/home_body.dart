import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/home/widgets/banner.dart';
import 'package:omeg_bazaar/screens/home/widgets/home_categories.dart';
import 'package:omeg_bazaar/screens/home/widgets/home_products.dart';
import 'package:omeg_bazaar/screens/home/widgets/search_bar.dart';
import 'package:omeg_bazaar/services/get_category_api.dart';
import 'package:omeg_bazaar/services/get_product_by_category.dart';
import 'package:omeg_bazaar/services/get_products_api.dart';

class HomeBody extends StatefulWidget {
  final VoidCallback onSeeAllPressed;
  const HomeBody({super.key, required this.onSeeAllPressed});
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List categories = [];
  List<Map<String, dynamic>> displayedProducts = [];
  String selectedCategory = '';
  bool isCategoryLoading = true;
  bool isProductsLoading = true;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await Future.wait([fetchCategories(), fetchAllProducts()]);
  }

  Future<void> fetchCategories() async {
    try {
      final data = await GetCategoryApiCall().get();
      setState(() {
        categories = data;
        isCategoryLoading = false;
      });
    } catch (e) {
      // print('Category fetch error: $e');
      setState(() {
        isCategoryLoading = false;
      });
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      final data = await GetProductsApiCall().getProducts();
      final topProducts = data.cast<Map<String, dynamic>>().take(10).toList();
      setState(() {
        displayedProducts = topProducts;
        isProductsLoading = false;
        selectedCategory = '';
      });
    } catch (e) {
      // print('All products fetch error: $e');
      setState(() {
        isProductsLoading = false;
      });
    }
  }

  Future<void> fetchProductsByCategory(String categoryName) async {
    setState(() {
      isProductsLoading = true;
      selectedCategory = categoryName;
    });

    try {
      final data = await GetProdByCategory().getProductsByCategory(
        categoryName,
      );
      setState(() {
        displayedProducts = data.cast<Map<String, dynamic>>();
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSearchBar(),
            const SizedBox(height: 15),
            const MyBanner(),
            const SizedBox(height: 10),

            CategoriesOnHomePage(
              categories: categories,
              isCategoryLoading: isCategoryLoading,
              selectedCategory: selectedCategory,
              onCategoryTap: fetchProductsByCategory,
            ),

            const SizedBox(height: 20),
            ProductsOnHomePage(
              displayedProducts: displayedProducts,
              isLoading: isProductsLoading,
              selectedCategory: selectedCategory,
              onSeeAllPressed: widget.onSeeAllPressed,
            ),
          ],
        ),
      ),
    );
  }
}
