import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/home/widgets/banner.dart';
import 'package:omeg_bazaar/screens/home/widgets/home_categories.dart';
import 'package:omeg_bazaar/screens/home/widgets/search_bar.dart';
import 'package:omeg_bazaar/services/product/get_category_api.dart';
import 'package:omeg_bazaar/services/product/get_product_by_query.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:omeg_bazaar/widgets/common/loaders/product_card_shimmer.dart';
import 'package:omeg_bazaar/widgets/common/product/product_card.dart';
import 'package:omeg_bazaar/widgets/common/round_btn.dart';
import 'package:omeg_bazaar/widgets/common/title.dart';

class HomeBody extends StatefulWidget {
  final VoidCallback onSeeAllPressed;
  final double screenWidth;

  const HomeBody({
    super.key,
    required this.onSeeAllPressed,
    required this.screenWidth,
  });

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List categories = [];
  List<Map<String, dynamic>> displayedProducts = [];
  String selectedCategoryId = '';
  bool isCategoryLoading = true;
  bool isProductsLoading = true;
  String searchQuery = '';
  bool isSearching = false;
  final GetFilteredProducts _productsService = GetFilteredProducts();

  String getCategoryName(String id) {
    if (id.isEmpty) return '';
    final category = categories.firstWhere(
      (c) => c['_id'] == id,
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
        );
        setState(() {
          displayedProducts = data;
        });
      }
    } catch (e) {
      // Handle error
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
      final data = await _productsService.fetchFilteredProducts();
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
      );
      setState(() => displayedProducts = data);
    } catch (e) {
      // Handle error
    } finally {
      setState(() => isProductsLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = widget.screenWidth < 600;
    final paddingValue = isSmallScreen ? 12.0 : 24.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingValue),
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchBarDelegate(
              onSearch: searchProducts,
              isSmallScreen: isSmallScreen,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isSmallScreen ? 15 : 25),
                MyBanner(isSmallScreen: isSmallScreen),
                SizedBox(height: isSmallScreen ? 10 : 20),
                CategoriesOnHomePage(
                  categories: categories,
                  isCategoryLoading: isCategoryLoading,
                  selectedCategoryId: selectedCategoryId,
                  onCategoryTap: fetchProductsByCategory,
                  isSmallScreen: isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 20 : 30),
                ProductsOnHomePage(
                  displayedProducts: displayedProducts,
                  isLoading: isProductsLoading,
                  selectedCategoryName:
                      selectedCategoryId.isEmpty
                          ? ''
                          : getCategoryName(selectedCategoryId),
                  onSeeAllPressed: widget.onSeeAllPressed,
                  isSearching: isSearching,
                  productLimit: isSmallScreen ? 10 : 15,
                  screenWidth: widget.screenWidth,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: isSmallScreen ? 20 : 30),
                  child: Center(
                    child: RoundButton(
                      onTap: widget.onSeeAllPressed,
                      title: 'See All Products',
                      bgColor: AppColour.primaryColor,
                      borderRadius: 60,
                      width: isSmallScreen ? 180 : 220,
                      height: isSmallScreen ? 45 : 50,
                    ),
                  ),
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
  final bool isSmallScreen;

  _SearchBarDelegate({required this.onSearch, required this.isSmallScreen});

  @override
  double get minExtent => isSmallScreen ? 70 : 80;
  @override
  double get maxExtent => isSmallScreen ? 80 : 90;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(isSmallScreen ? 4 : 8),
      alignment: Alignment.centerLeft,
      child: CustomSearchBar(onSearch: onSearch, isSmallScreen: isSmallScreen),
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) =>
      oldDelegate.onSearch != onSearch ||
      oldDelegate.isSmallScreen != isSmallScreen;
}

class ProductsOnHomePage extends StatelessWidget {
  final String selectedCategoryName;
  final List<Map<String, dynamic>> displayedProducts;
  final bool isLoading;
  final VoidCallback onSeeAllPressed;
  final bool isSearching;
  final int productLimit;
  final double screenWidth;

  const ProductsOnHomePage({
    super.key,
    required this.displayedProducts,
    required this.isLoading,
    required this.onSeeAllPressed,
    required this.isSearching,
    required this.selectedCategoryName,
    required this.productLimit,
    required this.screenWidth,
  });

  int _calculateCrossAxisCount() {
    if (screenWidth > 1200) return 4;
    if (screenWidth > 800) return 3;
    if (screenWidth > 600) return 2;
    return 2; // Default for small screens
  }

  double _calculateChildAspectRatio() {
    if (screenWidth > 1200) return 0.85;
    if (screenWidth > 800) return 0.80;
    return 0.75; // Default for smaller screens
  }

  @override
  Widget build(BuildContext context) {
    final productsToShow =
        isSearching
            ? displayedProducts
            : displayedProducts.take(productLimit).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          title:
              isSearching
                  ? 'Search Results'
                  : selectedCategoryName.isEmpty
                  ? 'Top Picks for You'
                  : 'Products in "$selectedCategoryName"',
          onSeeAll: onSeeAllPressed,
          isSmallScreen: screenWidth < 600,
        ),
        SizedBox(height: screenWidth < 600 ? 10 : 20),
        isLoading
            ? ProductCardShimmer(
              crossAxisCount: _calculateCrossAxisCount(),
              childAspectRatio: _calculateChildAspectRatio(),
            )
            : productsToShow.isEmpty
            ? Center(
              child: Padding(
                padding: EdgeInsets.all(screenWidth < 600 ? 16 : 24),
                child: Text(
                  "No products found.",
                  style: TextStyle(fontSize: screenWidth < 600 ? 16 : 20),
                ),
              ),
            )
            : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productsToShow.length,
              padding: EdgeInsets.only(top: screenWidth < 600 ? 20 : 30),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _calculateCrossAxisCount(),
                crossAxisSpacing: screenWidth < 600 ? 10 : 15,
                mainAxisSpacing: screenWidth < 600 ? 10 : 15,
                childAspectRatio: _calculateChildAspectRatio(),
              ),
              itemBuilder: (context, index) {
                return ProductCard(
                  product: productsToShow[index],
                  isSmallScreen: screenWidth < 600,
                );
              },
            ),
      ],
    );
  }
}
