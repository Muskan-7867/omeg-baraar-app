import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/checkout/local_data_handler.dart';
import 'package:omeg_bazaar/services/order/buy_now_product_api.dart';
import 'package:omeg_bazaar/services/order/cart_products_order_api.dart';
import 'package:omeg_bazaar/utills/api_constants.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentHandler {
  final Razorpay _razorpay;
  final BuildContext context;
  final bool isBuyNow;
  final String? authToken;
  final List<dynamic> cartProducts;
  final List<int> quantities;
  final Map<String, dynamic>? selectedAddress;
  final Map<String, dynamic>? userAddress;

  PaymentHandler({
    required this.context,
    required this.isBuyNow,
    required this.cartProducts,
    required this.quantities,
    this.authToken,
    this.selectedAddress,
    this.userAddress,
  }) : _razorpay = Razorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  Future<void> processPayment() async {
    if (cartProducts.isEmpty) {
      _showSnackBar('No products in cart');
      return;
    }

    final addressToUse = selectedAddress ?? userAddress;
    if (addressToUse == null || addressToUse.isEmpty) {
      _showSnackBar('Please add a shipping address');
      return;
    }

    final standardizedAddress = _standardizeAddress(addressToUse);

    if (authToken == null && !isBuyNow) {
      _showSnackBar('Authentication required');
      return;
    }

    try {
      final userData = await LocalDataHandler.loadUserData();
      final contact = userAddress?['phone']?.toString() ?? '';
      final email = userData['userData']?['user']?['email']?.toString() ?? '';

      dynamic response;
      if (isBuyNow) {
        final product = cartProducts[0];
        final quantity = quantities[0];
        response = await BuyNowProductApi.createRazorpayOrder(
          productId: product['_id'],
          address: standardizedAddress,
          quantity: quantity,
          paymentMethod: 'Razorpay',
        );
      } else {
        final cartProductIds =
            cartProducts.map((product) => product['_id'].toString()).toList();

        response = await CartProductsOrderApi.createRazorPayOrderOfCart(
          cartProductIds: cartProductIds,
          address: standardizedAddress,
          quantities: quantities,
          paymentMethod: 'Razorpay',
          token: authToken,
        );
      }

      if (response['success'] == false) {
        throw Exception(response['message'] ?? 'Failed to create order');
      }

      final orderId =
          isBuyNow
              ? response['orderId']?.toString()
              : response['order']?['_id']?.toString();

      if (orderId == null) {
        throw Exception('Failed to extract order ID from response');
      }

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

      _razorpay.open(options);
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
      rethrow;
    }
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

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (response.orderId == null ||
        response.paymentId == null ||
        response.signature == null) {
      _showSnackBar('Payment verification failed: Missing payment data');
      return;
    }

    try {
      bool verified;

      if (isBuyNow) {
        verified = await BuyNowProductApi.verifyPayment(
          orderId: response.orderId!,
          razorpayOrderId: response.orderId!,
          paymentId: response.paymentId!,
          razorpaySignature: response.signature!,
          paymentMethod: 'Razorpay',
        );
      } else {
        if (authToken == null) {
          _showSnackBar('Authentication required');
          return;
        }
        verified = await CartProductsOrderApi.verifyCartPayment(
          orderId: response.orderId!,
          razorpayOrderId: response.orderId!,
          paymentId: response.paymentId!,
          razorpaySignature: response.signature!,
          paymentMethod: 'Razorpay',
          token: authToken!,
        );
      }

      if (verified) {
        _showSnackBar('Order placed and verified successfully');
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        _showSnackBar('Payment verification failed');
      }
    } catch (e) {
      _showSnackBar('Error verifying payment: $e');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showSnackBar('Payment Failed: ${response.message ?? 'Unknown error'}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showSnackBar('External Wallet: ${response.walletName}');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
