// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:mtouch/view/screens/cart_screen.dart';
import 'package:mtouch/view/screens/product_detail_screen.dart';
import 'package:mtouch/view/screens/splash.dart';

import '../view/screens/add_edit_product_screen.dart';
import '../view/screens/product_list_screen.dart';


class AppRoutes {
  static const String SPLASH = '/splash';
  static const String PRODUCT_LIST = '/';
  static const String PRODUCT_DETAIL = '/product-detail';
  static const String ADD_EDIT_PRODUCT = '/add-edit-product';
  static const String CART = '/cart';

  static final routes = [
    GetPage(name: SPLASH, page: () => const SplashScreen()),
    GetPage(name: PRODUCT_LIST, page: () => ProductListScreen()),
    GetPage(name: PRODUCT_DETAIL, page: () => ProductDetailScreen()),
    GetPage(name: ADD_EDIT_PRODUCT, page: () => AddEditProductScreen()),
    GetPage(name: CART, page: () => CartScreen()),
  ];
}