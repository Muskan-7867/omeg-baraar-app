import 'package:flutter/widgets.dart';
import 'package:omeg_bazaar/screens/auth/forget_password.dart';
import 'package:omeg_bazaar/screens/auth/sign_in.dart';
import 'package:omeg_bazaar/screens/auth/sign_up.dart';
import 'package:omeg_bazaar/screens/auth/verify.dart';
import 'package:omeg_bazaar/screens/home/home.dart';
import 'package:omeg_bazaar/screens/intro/intro.dart';
import 'package:omeg_bazaar/screens/profile/myorders/order.dart';
import 'package:omeg_bazaar/screens/profile/payment-methods/payment_method.dart';
import 'package:omeg_bazaar/screens/product/products_page.dart';
import 'package:omeg_bazaar/screens/profile/profile.dart';
import 'package:omeg_bazaar/screens/profile/settings/settings.dart';
import 'package:omeg_bazaar/screens/singleproduct/single_product_screen.dart';
import 'package:omeg_bazaar/screens/splash_screen.dart';
import 'package:omeg_bazaar/screens/trackorder/order_track.dart';

class AppRouter {
  static const String splash = '/';
  static const String intro = '/intro';
  static const String home = '/home';
  static const String singleproduct = '/singleproduct';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verify = '/verify';
  static const String productspage = '/productspage';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String ordertrack = '/ordertrack';
  static const String forgetpassword = '/forgetpassword';
  static const String paymentmethod = '/paymentmethod';

  static Map<String, Widget Function(BuildContext)> getRoutes() => {
    splash: (context) => const SplashScreen(),
    intro: (context) => const Intro(),
    home: (context) => const Home(),
    singleproduct: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return SingleProduct(
        cartProducts: args?['cartProducts'] ?? [],
        quantities: args?['quantities'] ?? [],
      );
    },
    login: (context) => const UserLogin(),
    signup: (context) => const UserSignUp(),
    verify: (context) => const VerifyUser(),
    productspage: (context) => const ProductsPage(),
    orders: (context) => const MyOrders(),
    profile: (context) => const ProfileScreen(),
    settings: (context) => const Settings(),
    ordertrack: (context) => const OrderTrack(),
    paymentmethod: (context) => const PaymentMethod(),
    forgetpassword: (context) => const ForgetPassword(),
  };
}
