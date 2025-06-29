import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/product_search/product_search.dart';
import '../presentation/shopping_cart/shopping_cart.dart';
import '../presentation/product_detail/product_detail.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String homeScreen = '/home-screen';
  static const String productSearch = '/product-search';
  static const String shoppingCart = '/shopping-cart';
  static const String productDetail = '/product-detail';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    homeScreen: (context) => const HomeScreen(),
    productSearch: (context) => const ProductSearch(),
    shoppingCart: (context) => const ShoppingCart(),
    productDetail: (context) => const ProductDetail(),
    // TODO: Add your other routes here
  };
}
