import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/checkout/order_list_data.dart';
import 'package:omeg_bazaar/screens/checkout/order_summary.dart';
import 'package:omeg_bazaar/services/order/buy_now_product_api.dart';
import 'package:omeg_bazaar/services/order/cart_products_order_api.dart';
import 'package:omeg_bazaar/utills/api_constants.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderList extends StatefulWidget {
  final List<dynamic> cartProducts;
  final List<int> quantities;
  final bool isBuyNow;

  const OrderList({
    super.key,
    required this.cartProducts,
    required this.quantities,
    this.isBuyNow = false,
  });

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  late final Razorpay _razorpay;
  bool _isPaymentWindowOpen = false;
  bool _isLoading = false;
  String? _orderId;
  String? _errorMessage;
  String? _authToken;
  Map<String, dynamic>? _userAddress;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString('authToken');
      final addressJson = prefs.getString('useraddress');
      if (addressJson != null && addressJson.isNotEmpty) {
        try {
          dynamic decoded = jsonDecode(addressJson);
          if (decoded is String) {
            decoded = jsonDecode(decoded);
          }
          if (decoded is Map<String, dynamic>) {
            _userAddress = decoded;
          } else {
            debugPrint('Unexpected address format: ${decoded.runtimeType}');
          }
        } catch (e) {
          debugPrint('Error decoding address: $e');
          try {
            _userAddress = jsonDecode(addressJson) as Map<String, dynamic>?;
          } catch (e) {
            debugPrint('Fallback decoding failed: $e');
          }
        }
      }
      setState(() => _isLoadingData = false);
    } catch (e) {
      debugPrint('Error loading data: $e');
      setState(() {
        _isLoadingData = false;
        _errorMessage = 'Failed to load address';
      });
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _createRazorpayOrder() async {
    if (widget.cartProducts.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No products in cart')));
      return;
    }

    if (_userAddress == null || _userAddress!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid address format')));
      return;
    }

    if (_authToken == null && !widget.isBuyNow) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Authentication required')));
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get user data from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      Map<String, dynamic>? userData;
      if (userDataString != null) {
        userData = json.decode(userDataString) as Map<String, dynamic>;
      }

      String email = ''; // default
      String contact = ''; // default

      // Get email from user data if available
      if (userData != null &&
          userData['user'] != null &&
          userData['user']['email'] != null) {
        email = userData['user']['email'].toString();
      }

      // Get contact from address if available
      if (_userAddress != null && _userAddress!['phone'] != null) {
        contact = _userAddress!['phone'].toString();
      }

      dynamic response;
      if (widget.isBuyNow) {
        final product = widget.cartProducts[0];
        final quantity = widget.quantities[0];
        response = await BuyNowProductApi.createRazorpayOrder(
          productId: product['_id'],
          address: _userAddress,
          quantity: quantity,
          paymentMethod: 'Razorpay',
        );
      } else {
        final cartProductIds =
            widget.cartProducts
                .map((product) => product['_id'].toString())
                .toList();

        response = await CartProductsOrderApi.createRazorPayOrderOfCart(
          cartProductIds: cartProductIds,
          address: _userAddress,
          quantities: widget.quantities,
          paymentMethod: 'Razorpay',
          token: _authToken,
        );
      }

      if (response['success'] == false) {
        throw Exception(response['message'] ?? 'Failed to create order');
      }

      debugPrint('API Response: $response');

      if (widget.isBuyNow) {
        _orderId = response['orderId']?.toString();
      } else {
        _orderId = response['order']?['_id']?.toString();
      }

      if (_orderId == null) {
        debugPrint(
          'Order ID not found in response. Available keys: ${response.keys}',
        );
        throw Exception('Failed to extract order ID from response');
      }

      debugPrint('Extracted Order ID: $_orderId');
      final razorpayOrder = response['razorpayOrder'];
      if (razorpayOrder == null) {
        throw Exception('Razorpay order data not found in response');
      }

      final options = {
        'key': ApiConstants.razorPayId,
        'amount': razorpayOrder['amount'].toString(),
        'currency': razorpayOrder['currency'],
        'name': 'Omeg Bazaar',
        'description': 'Order Payment',
        'order_id': razorpayOrder['id'],
        'prefill': {'contact': contact, 'email': email},
        'theme': {
          'color':
              '#${AppColour.primaryColor.value.toRadixString(16).substring(2)}',
          'background': '#ffffff',
        },
      };

      setState(() {
        _isPaymentWindowOpen = true;
      });
      _razorpay.open(options);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      _isPaymentWindowOpen = false;
    });

    if (_orderId == null ||
        response.orderId == null ||
        response.paymentId == null ||
        response.signature == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment verification failed: Missing payment data'),
        ),
      );
      return;
    }

    try {
      bool verified;
      final token = _authToken;

      if (widget.isBuyNow) {
        verified = await BuyNowProductApi.verifyPayment(
          orderId: _orderId!,
          razorpayOrderId: response.orderId!,
          paymentId: response.paymentId!,
          razorpaySignature: response.signature!,
          paymentMethod: 'Razorpay',
        );
      } else {
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication required')),
          );
          return;
        }
        verified = await CartProductsOrderApi.verifyCartPayment(
          orderId: _orderId!,
          razorpayOrderId: response.orderId!,
          paymentId: response.paymentId!,
          razorpaySignature: response.signature!,
          paymentMethod: 'Razorpay',
          token: token,
        );
      }

      if (verified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed and verify successfully')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment verification failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error verifying payment: $e')));
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isPaymentWindowOpen = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message ?? 'Unknown error'}'),
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColour.primaryColor,
              ),
              width: double.infinity,
              child: TextButton(
                onPressed: _isLoading ? null : _createRazorpayOrder,
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
      ),
    );
  }
}
