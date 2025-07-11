import 'package:flutter/widgets.dart';
import 'package:omegbazaar/screens/auth/forget_password.dart';
import 'package:omegbazaar/screens/auth/sign_in.dart';
import 'package:omegbazaar/screens/auth/sign_up.dart';
import 'package:omegbazaar/screens/auth/verify.dart';
import 'package:omegbazaar/screens/checkout/add_address.dart';
import 'package:omegbazaar/screens/home/home.dart';
import 'package:omegbazaar/screens/intro/intro.dart';
import 'package:omegbazaar/screens/profile/myorders/my_orders.dart';
import 'package:omegbazaar/screens/profile/payment-methods/payment_method.dart';
import 'package:omegbazaar/screens/product/products_page.dart';
import 'package:omegbazaar/screens/profile/policies/policies.dart';

import 'package:omegbazaar/screens/profile/user_profile.dart';
import 'package:omegbazaar/screens/profile/settings/settings.dart';
import 'package:omegbazaar/screens/singleproduct/single_product_screen.dart';
import 'package:omegbazaar/screens/splash_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String intro = '/intro';
  static const String home = '/home';
  static const String singleproduct = '/singleproduct';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verify = '/verify';
  static const String products = '/products';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String ordertrack = '/ordertrack';
  static const String forgetpassword = '/forgetpassword';
  static const String paymentmethod = '/paymentmethod';
  static const String addressform = '/addressform';
    static const String privacy = '/privacy';

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
    products: (context) => const ProductsPage(),
    orders: (context) => const MyOrders(),
    profile: (context) => const ProfileScreen(),
    settings: (context) => const Settings(),
    paymentmethod: (context) => const PaymentMethod(),
    forgetpassword: (context) => const ForgetPassword(),
    addressform: (context) => const AddressForm(),
    privacy: (context) => const Policies(),

  };
}
