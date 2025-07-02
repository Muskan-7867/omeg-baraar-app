// lib/services/razorpay_handler.dart
import 'package:flutter/material.dart';
import 'package:omeg_bazaar/services/order/buy_now_product_api.dart';
import 'package:omeg_bazaar/services/order/cart_products_order_api.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayHandler {
  final Razorpay _razorpay;
  final BuildContext context;
  final bool isBuyNow;
  final String? authToken;

  RazorpayHandler({
    required this.context,
    required this.isBuyNow,
    this.authToken,
  }) : _razorpay = Razorpay();

  void initialize({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    required Function(ExternalWalletResponse) onExternalWallet,
  }) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  Future<void> createOrder({
    required List<dynamic> cartProducts,
    required List<int> quantities,
    required Map<String, dynamic>? userAddress,
    required Function(String?) onOrderCreated,
    required Function(String) onError,
  }) async {
    try {
      dynamic response;
      if (isBuyNow) {
        final product = cartProducts[0];
        final quantity = quantities[0];
        response = await BuyNowProductApi.createRazorpayOrder(
          productId: product['_id'],
          address: userAddress,
          quantity: quantity,
          paymentMethod: 'Razorpay',
        );
      } else {
        final cartProductIds =
            cartProducts.map((product) => product['_id'].toString()).toList();
        response = await CartProductsOrderApi.createRazorPayOrderOfCart(
          cartProductIds: cartProductIds,
          address: userAddress,
          quantities: quantities,
          paymentMethod: 'Razorpay',
          token: authToken,
        );
      }

      if (response['success'] == false) {
        throw Exception(response['message'] ?? 'Failed to create order');
      }

      final orderId = response['orderId'];
      final razorpayOrder = response['razorpayOrder'];

      final options = {
        'key': 'rzp_test_XSMd17B3zbeJ02',
        'amount': razorpayOrder['amount'].toString(),
        'currency': razorpayOrder['currency'],
        'name': 'Omeg Bazaar',
        'description': 'Order Payment',
        'order_id': razorpayOrder['id'],
        'prefill': {'contact': '8888888888', 'email': 'customer@example.com'},
        'theme': {
          'color': '#FF0000', // You can replace this with your actual color
          'background': '#ffffff',
        },
      };

      onOrderCreated(orderId);
      _razorpay.open(options);
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> verifyPayment({
    required String orderId,
    required String razorpayOrderId,
    required String paymentId,
    required String razorpaySignature,
    required Function(bool) onVerificationComplete,
    required Function(String) onError,
  }) async {
    try {
      bool verified;
      if (isBuyNow) {
        verified = await BuyNowProductApi.verifyPayment(
          orderId: orderId,
          razorpayOrderId: razorpayOrderId,
          paymentId: paymentId,
          razorpaySignature: razorpaySignature,
          paymentMethod: 'Razorpay',
        );
      } else {
        verified = await CartProductsOrderApi.verifyCartPayment(
          orderId: orderId,
          razorpayOrderId: razorpayOrderId,
          paymentId: paymentId,
          razorpaySignature: razorpaySignature,
          paymentMethod: 'Razorpay',
          token: authToken,
        );
      }
      onVerificationComplete(verified);
    } catch (e) {
      onError(e.toString());
    }
  }
}
