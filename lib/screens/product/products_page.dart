import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/product/widget/products_list.dart';
import 'package:omeg_bazaar/services/get_products_api.dart';
import 'package:omeg_bazaar/widgets/common/filter_bar.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final GetProductsApiCall _api = GetProductsApiCall();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await _api.getProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const FilterBar(),
      body: SafeArea(
        child: Builder(
          builder:
              (context) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.8,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              // You can filter products here
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(60),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              hintText: 'Search',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: IconButton(
                            onPressed: () {
                              Scaffold.of(
                                context,
                              ).openDrawer(); // ✅ Works inside Builder
                            },
                            icon: const Icon(
                              Icons.filter_list,
                              size: 36,
                              color: Colors.black,
                            ),
                          ),
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
