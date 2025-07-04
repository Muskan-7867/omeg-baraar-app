import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/home/widgets/banner.dart';
import 'package:omeg_bazaar/screens/home/widgets/home_categories.dart';
import 'package:omeg_bazaar/screens/home/widgets/search_bar.dart';
import 'package:omeg_bazaar/services/product/get_category_api.dart';
import 'package:omeg_bazaar/services/product/get_product_by_query.dart';
import 'package:omeg_bazaar/widgets/common/loaders/product_card_shimmer.dart';
import 'package:omeg_bazaar/widgets/common/product/product_card.dart';
import 'package:omeg_bazaar/widgets/common/title.dart';

class HomeBody extends StatefulWidget {
  final VoidCallback onSeeAllPressed;
  const HomeBody({super.key, required this.onSeeAllPressed});
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List categories = [];
  List<Map<String, dynamic>> displayedProducts = [];
  String selectedCategoryId = ''; // Changed from selectedCategory to selectedCategoryId
  bool isCategoryLoading = true;
  bool isProductsLoading = true;
  String searchQuery = '';
  bool isSearching = false;
  final GetFilteredProducts _productsService = GetFilteredProducts();

  // Helper method to get category name from ID
  String getCategoryName(String id) {
    if (id.isEmpty) return '';
    final category = categories.firstWhere(
      (c) => c['_id'] == id, // Assuming your category objects have '_id' field
      orElse: () => {'name': ''},
    );
    return category['name'];
  }

  Future<void> searchProducts(String query) async {
    setState(() {
      isProductsLoading = true;
      searchQuery = query;
      isSearching = query.isNotEmpty;
      selectedCategoryId = '';
    });

    try {
      if (query.isEmpty) {
        await fetchAllProducts();
      } else {
        final data = await _productsService.fetchFilteredProducts(
          search: query,
          limit: 10,
        );
        setState(() {
          displayedProducts = data;
        });
      }
    } catch (e) {
      print('Search error: $e');
    } finally {
      setState(() {
        isProductsLoading = false;
      });
    }
  }

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
      setState(() {
        isCategoryLoading = false;
      });
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      final data = await _productsService.fetchFilteredProducts(limit: 10);
      setState(() {
        displayedProducts = data;
        isProductsLoading = false;
        selectedCategoryId = '';
        isSearching = false;
      });
    } catch (e) {
      setState(() {
        isProductsLoading = false;
      });
    }
  }

  Future<void> fetchProductsByCategory(String categoryId) async {
    setState(() {
      isProductsLoading = true;
      selectedCategoryId = categoryId;
      isSearching = false;
    });

    try {
      final data = await _productsService.fetchFilteredProducts(
        category: categoryId,
        limit: 10,
      );
      setState(() => displayedProducts = data);
    } catch (e) {
      print('Product fetch error: $e');
    } finally {
      setState(() => isProductsLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchBarDelegate(
              onSearch: searchProducts,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                const MyBanner(),
                const SizedBox(height: 10),
                CategoriesOnHomePage(
                  categories: categories,
                  isCategoryLoading: isCategoryLoading,
                  selectedCategoryId: selectedCategoryId,
                  onCategoryTap: fetchProductsByCategory,
                ),
                const SizedBox(height: 20),
                ProductsOnHomePage(
                  displayedProducts: displayedProducts,
                  isLoading: isProductsLoading,
                  selectedCategoryName: selectedCategoryId.isEmpty
                      ? ''
                      : getCategoryName(selectedCategoryId),
                  onSeeAllPressed: widget.onSeeAllPressed,
                  isSearching: isSearching,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Function(String) onSearch;

  _SearchBarDelegate({required this.onSearch});

  @override
  double get minExtent => 70;
  @override
  double get maxExtent => 80;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(4),
      alignment: Alignment.centerLeft,
      child: CustomSearchBar(onSearch: onSearch),
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) =>
      oldDelegate.onSearch != onSearch;
}

class ProductsOnHomePage extends StatelessWidget {
  final String selectedCategoryName;
  final List<Map<String, dynamic>> displayedProducts;
  final bool isLoading;
  final VoidCallback onSeeAllPressed;
  final bool isSearching;

  const ProductsOnHomePage({
    super.key,
    required this.displayedProducts,
    required this.isLoading,
    required this.onSeeAllPressed,
    required this.isSearching,
    required this.selectedCategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          title: isSearching
              ? 'Search Results'
              : selectedCategoryName.isEmpty
                  ? 'Top Picks for You'
                  : 'Products in "$selectedCategoryName"',
          onSeeAll: onSeeAllPressed,
        ),
        const SizedBox(height: 10),
        isLoading
            ? const ProductCardShimmer()
            : displayedProducts.isEmpty
                ? const Center(child: Text("No products found."))
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayedProducts.length,
                    padding: const EdgeInsets.only(top: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(product: displayedProducts[index]);
                    },
                  ),
      ],
    );
  }
}