import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/checkout/order_summary.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderList extends StatefulWidget {
  final List<dynamic> cartProducts;
  final List<int> quantities;

  const OrderList({
    super.key,
    required this.cartProducts,
    required this.quantities,
  });

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  late final Razorpay _razorpay;
  bool _isPaymentWindowOpen = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckout() {
    double total = 0;
    double deliveryCharges = 0;

    for (int i = 0; i < widget.cartProducts.length; i++) {
      final product = widget.cartProducts[i];
      final qty = widget.quantities[i];
      final double price = product['price']?.toDouble() ?? 0;
      final double delivery = product['deliveryCharges']?.toDouble() ?? 0;
      total += price * qty;
      deliveryCharges += delivery;
    }

    double averageDeliveryCharges =
        widget.cartProducts.isNotEmpty
            ? deliveryCharges / widget.cartProducts.length
            : 0;

    double grandTotal = total + averageDeliveryCharges;
    if (grandTotal <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid order amount')));
      return;
    }

    int amount = (grandTotal * 100).toInt();
    debugPrint('Payment Amount: $amount paise');

    var options = {
      'key': 'rzp_test_XSMd17B3zbeJ02',
      'amount': amount.toString(),
      'name': 'Omeg Bazaar',
      'description': 'Order Payment',
      'prefill': {'contact': '8888888888', 'email': 'customer@example.com'},
      'theme': {
        'color':
            '#${AppColour.primaryColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
        'background': '#ffffff',

        'topbar': {
          'padding': {'top': '48'},
        },
      },
      'modal_color':
          '#${AppColour.primaryColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
    };

    try {
      setState(() {
        _isPaymentWindowOpen = true;
      });
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Exception: ${e.toString()}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      setState(() {
        _isPaymentWindowOpen = false;
      });
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _isPaymentWindowOpen = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isPaymentWindowOpen = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      _isPaymentWindowOpen = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(top: _isPaymentWindowOpen ? 70 : 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Text(
              'Order List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartProducts.length,
              itemBuilder: (context, index) {
                final product = widget.cartProducts[index];
                final qty = widget.quantities[index];
                return ListTile(
                  leading: Image.network(
                    product['images'][0]['url'],
                    width: 50,
                    height: 50,
                  ),
                  title: Text(product['name']),
                  subtitle: Text('Rs. ${product['price'].toString()} /-'),
                  trailing: Text(qty.toString()),
                );
              },
            ),
          ),
          OrderSummary(
            cartProducts: widget.cartProducts,
            quantities: widget.quantities,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColour.primaryColor,
              ),
              width: double.infinity,
              child: TextButton(
                onPressed: openCheckout,
                child: const Text(
                  'Continue to Payment',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
