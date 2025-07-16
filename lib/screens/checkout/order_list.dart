import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/checkout/order_list_data.dart';
import 'package:omeg_bazaar/screens/checkout/order_summary.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'local_data_handler.dart';
import 'payment_handler.dart';

class OrderList extends StatefulWidget {
  final List<dynamic> cartProducts;
  final List<int> quantities;
  final bool isBuyNow;
  final Map<String, dynamic>? selectedAddress;

  const OrderList({
    super.key,
    required this.cartProducts,
    required this.quantities,
    this.isBuyNow = false,
    this.selectedAddress,
  });

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  bool _isLoading = false;
  bool _isLoadingData = true;
  String? _errorMessage;
  PaymentHandler? _paymentHandler;
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    setState(() => _isLoadingData = true);
    try {
      _userData = await LocalDataHandler.loadUserData();
    } catch (e) {
      setState(() => _errorMessage = 'Failed to load user data');
      debugPrint('Error loading data: $e');
    } finally {
      setState(() => _isLoadingData = false);
    }
  }

  Future<void> _processPayment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _paymentHandler = PaymentHandler(
        context: context,
        isBuyNow: widget.isBuyNow,
        cartProducts: widget.cartProducts,
        quantities: widget.quantities,
        authToken: _userData['authToken'],
        selectedAddress: widget.selectedAddress,
        userAddress: _userData['userAddress'],
      );

      await _paymentHandler!.processPayment();
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _paymentHandler?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Order List',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        OrderData(
          cartProducts: widget.cartProducts,
          quantities: widget.quantities,
        ),
        OrderSummary(
          cartProducts: widget.cartProducts,
          quantities: widget.quantities,
          isBuyNow: widget.isBuyNow,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColour.primaryColor,
            ),
            width: double.infinity,
            child: TextButton(
              onPressed: _isLoading ? null : _processPayment,
              child:
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        'Continue to Payment',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
            ),
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
