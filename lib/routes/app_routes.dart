import 'package:flutter/material.dart';

import '../features/auth/screens/welcome.dart';
import '../features/auth/screens/user_login.dart';
import '../features/auth/screens/admin_login.dart';
import '../features/user/pos/screens/pos_product_screen.dart';
import '../features/user/pos/screens/consigment/consignment_screen.dart';

class AppRoutes {
  static const welcome = '/';
  static const loginUser = '/login-user';
  static const loginAdmin = '/admin-login';
  static const userPosProduct = '/user/pos-product';
  static const userConsignment = '/user/consignment';

  static Map<String, WidgetBuilder> routes = {
    welcome: (_) => const WelcomeScreen(),
    loginUser: (_) => const UserLogin(),
    loginAdmin: (_) => const AdminLogin(),
    userPosProduct: (_) => const PosProductScreen(),
    userConsignment: (_) => const ConsignmentScreen(),
  };
}
