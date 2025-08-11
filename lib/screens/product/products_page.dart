import 'dart:async';
import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/product/widget/products_list.dart';
import 'package:omeg_bazaar/services/product/get_product_by_query.dart';
import 'package:omeg_bazaar/screens/product/widget/filter_bar.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final GetFilteredProducts _productService = GetFilteredProducts();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String? _selectedCategory;
  double _minPrice = 0;
  double _maxPrice = 1000000000000;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchRelatedProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = _searchController.text.trim();
        _fetchRelatedProducts();
      });
    });
  }

  Future<void> _fetchRelatedProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _productService.fetchFilteredProducts(
        category: _selectedCategory,
        search: _searchQuery,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
      );
      setState(() => _products = products);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _selectedCategory = filters['category'];
      _minPrice = filters['minPrice'] ?? 0;
      _maxPrice = filters['maxPrice'] ?? 1000000000000;
      _fetchRelatedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: FilterBar(onApplyFilters: _applyFilters),
      body: SafeArea(
        child: Builder(
          builder:
              (context) => Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 10 : 15,
                                horizontal: isSmallScreen ? 20 : 25,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(60),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(60),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Search',
                            ),
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 14 : 20),
                        IconButton(
                          icon: Icon(
                            Icons.filter_list,
                            size: isSmallScreen ? 32 : 36,
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ],
                    ),
                  ),
                  ProductList(
                    products: _products,
                    isLoading: _isLoading,
                    errorMessage: _errorMessage,
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
