import 'package:flutter/widgets.dart';
import 'package:omeg_bazaar/screens/auth/sign_in.dart';
import 'package:omeg_bazaar/screens/auth/signup.dart';
import 'package:omeg_bazaar/screens/auth/verify.dart';
import 'package:omeg_bazaar/screens/home/home.dart';
import 'package:omeg_bazaar/screens/intro/intro.dart';
import 'package:omeg_bazaar/screens/profile/myorders/order.dart';
import 'package:omeg_bazaar/screens/profile/payment-methods/payment_method.dart';
import 'package:omeg_bazaar/screens/product/products_page.dart';
import 'package:omeg_bazaar/screens/product/widget/price_slider.dart';
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
  static const String priceSlider = '/priceslider';
  static const String productspage = '/productspage';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String  ordertrack = '/ordertrack';
  static const String paymentmethod = '/paymentmethod';

  static Map<String, Widget Function(BuildContext)> getRoutes() => {
    splash: (context) => SplashScreen(),
    intro: (context) => Intro(),
    home: (context) => Home(),
    singleproduct: (context) => SingleProduct(),
    login: (context) => UserLogin(),
    signup: (context) => UserSignUp(),
    verify: (context) => VerifyUser(),
    productspage: (context) => ProductsPage(),
    priceSlider: (context) => PriceSlider(),
    orders: (context) => MyOrders(),
    profile: (context) => ProfileScreen(),
    settings: (context) => Settings(),
    ordertrack: (context) => OrderTrack(),
    paymentmethod: (context) => PaymentMethod(),
  };
}
