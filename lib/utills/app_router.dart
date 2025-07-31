import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:omeg_bazaar/app/bindings/app_bindings.dart';
import 'package:omeg_bazaar/screens/auth/forget_password.dart';
import 'package:omeg_bazaar/screens/auth/sign_in.dart';
import 'package:omeg_bazaar/screens/auth/sign_up.dart';
import 'package:omeg_bazaar/screens/checkout/add_address.dart';
import 'package:omeg_bazaar/screens/home/home.dart';
import 'package:omeg_bazaar/screens/intro/intro.dart';
import 'package:omeg_bazaar/screens/product/products_page.dart';
import 'package:omeg_bazaar/screens/profile/myorders/my_orders.dart';
import 'package:omeg_bazaar/screens/profile/payment-methods/payment_method.dart';
import 'package:omeg_bazaar/screens/profile/policies/policies.dart';
import 'package:omeg_bazaar/screens/profile/settings/settings.dart';
import 'package:omeg_bazaar/screens/profile/user_profile.dart';
import 'package:omeg_bazaar/screens/splash_screen.dart';

import 'package:omeg_bazaar/utills/app_pages.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.splash,
      page: () => SplashScreen(),
      binding: AppBindings(),
    ),
    GetPage(name: Routes.intro, page: () => Intro(), binding: AppBindings()),
    GetPage(name: Routes.home, page: () => Home(), binding: AppBindings()),

    GetPage(
      name: Routes.login,
      page: () => UserLogin(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => UserSignUp(),
      binding: AppBindings(),
    ),
    GetPage(name: Routes.intro, page: () => Intro(), binding: AppBindings()),
    GetPage(
      name: Routes.products,
      page: () => ProductsPage(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.orders,
      page: () => MyOrders(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfileScreen(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => Settings(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.paymentmethod,
      page: () => PaymentMethod(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.forgetpassword,
      page: () => ForgetPassword(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.addressform,
      page: () => AddressForm(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.privacy,
      page: () => Policies(),
      binding: AppBindings(),
    ),
  ];
}
