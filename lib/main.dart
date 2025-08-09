import 'package:flutter/material.dart';
import 'package:omeg_bazaar/app/bindings/app_bindings.dart';
import 'package:omeg_bazaar/provider/cart_provider.dart';
import 'package:omeg_bazaar/utills/app_pages.dart';
import 'package:omeg_bazaar/utills/app_router.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Center(
      child: Text(
        'Oops! Something broke',
        style: TextStyle(color: Colors.red, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  };

  // Check first launch status before running the app
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('first_launch') ?? true;
  final initialRoute = isFirstLaunch ? Routes.splash : Routes.home;

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

//tahi tera hamesha sidha splash te janda fir splash toh suru hunda

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CartProvider())],

      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Omeg-Bazaar',
        getPages: AppPages.pages,
        initialBinding: AppBindings(),

        routes: Routes.getRoutes(),
        initialRoute: Routes.splash,
      ),
    );
  }
}


//  eh ki kita aa 