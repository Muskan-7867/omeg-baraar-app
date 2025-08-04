import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/checkout/confirm_cod_order.dart';
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
    required this.selectedAddress, // Changed to required
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

  Future<void> _showPaymentMethodDialog() async {
    if (widget.selectedAddress == null) {
      _showSnackBar('Please select a shipping address before proceeding');
      return;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Payment Method'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(
                    Icons.money,
                    color: AppColour.primaryColor,
                  ),
                  title: const Text('Cash on Delivery (COD)'),
                  subtitle: const Text('Pay when you receive your order'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _navigateToCODScreen();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.payment,
                    color: AppColour.primaryColor,
                  ),
                  title: const Text('Online Payment'),
                  subtitle: const Text('Pay securely with Razorpay'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _processPayment(isCod: false);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToCODScreen() {
    if (widget.selectedAddress == null) {
      _showSnackBar('Please select a shipping address');
      return;
    }

    final standardizedAddress = _standardizeAddress(widget.selectedAddress!);

    // Calculate total amount
    double totalAmount = 0;
    for (int i = 0; i < widget.cartProducts.length; i++) {
      final product = widget.cartProducts[i];
      final quantity = widget.quantities[i];
      totalAmount += (product['price'] * quantity);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ConfirmCODScreen(
              cartProducts: widget.cartProducts,
              quantities: widget.quantities,
              address: standardizedAddress,
              totalAmount: totalAmount,
              isBuyNow: widget.isBuyNow,
              onConfirm: () => _processPayment(isCod: true),
            ),
      ),
    );
  }

  Map<String, dynamic> _standardizeAddress(Map<String, dynamic> address) {
    return {
      'phone': address['phoneNumber'] ?? address['phone'],
      'street': address['street'] ?? '',
      'city': address['city'],
      'state': address['state'],
      'pincode': address['postalCode'] ?? address['pincode'],
      'country': address['country'],
      'address': address['addressLine1'] ?? address['address'],
      'address1': address['addressLine2'] ?? address['address1'],
      '_id': address['_id'],
    };
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _processPayment({bool isCod = false}) async {
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
      );

      await _paymentHandler!.processPayment(isCod: isCod);
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
              onPressed: _isLoading ? null : _showPaymentMethodDialog,
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
