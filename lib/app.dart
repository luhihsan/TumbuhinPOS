import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tumbuhin POS',
      theme: ThemeData(useMaterial3: true),
      initialRoute: AppRoutes.welcome,
      routes: AppRoutes.routes,
    );
  }
}
