import 'package:flutter/material.dart';
import '../../../../routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const SizedBox(height: 18),

              Image.asset(
                'assets/logo_project.png', 
                height: 58,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 18),

              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/logo_app.png', 
                    height: 280,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const Text(
                'Login POS Management as',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: const Color(0xFF9CA3AF),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.loginUser),
                  child: const Text('User'),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.loginAdmin),
                  child: const Text('Admin'),
                ),
              ),

              const SizedBox(height: 18),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 14, color: Colors.grey),
                  SizedBox(width: 6),
                  Text(
                    'possystem.com',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
