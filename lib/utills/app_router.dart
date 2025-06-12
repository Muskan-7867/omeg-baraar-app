import 'package:flutter/widgets.dart';
import 'package:omeg_bazaar/screens/auth/sign_in.dart';
import 'package:omeg_bazaar/screens/auth/signup.dart';
import 'package:omeg_bazaar/screens/auth/verify.dart';
import 'package:omeg_bazaar/screens/home/home.dart';
import 'package:omeg_bazaar/screens/intro/intro.dart';
import 'package:omeg_bazaar/screens/myorders/order.dart';
import 'package:omeg_bazaar/screens/product/products_page.dart';
import 'package:omeg_bazaar/screens/product/widget/price_slider.dart';
import 'package:omeg_bazaar/screens/singleproduct/single_product_screen.dart';
import 'package:omeg_bazaar/screens/splash_screen.dart';

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
    orders: (context) => MyOrders()
  
  };
}
