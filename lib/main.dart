import 'package:flutter/material.dart';
import 'package:omegbazaar/provider/cart_provider.dart';
import 'package:omegbazaar/utills/app_router.dart';
import 'package:provider/provider.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Center(
      child: Text(
        'Oops! Something broke',
        style: TextStyle(color: Colors.red, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  };

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Omeg Bazaar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: AppRouter.getRoutes(),
      initialRoute: AppRouter.splash,
    );
  }
}
