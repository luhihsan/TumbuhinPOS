import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_services.dart'; 

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool rememberMe = false;
  bool obscure = true;
  bool isLoading = false;
  
  final AuthService _authService = AuthService();

  static const String logoPath = 'assets/logo_project.png';
  static const String heroPath = 'assets/logo_app.png';

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  // Fungsi untuk handle klik tombol login
  Future<void> _handleLogin() async {
    final email = emailC.text.trim();
    final password = passC.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password tidak boleh kosong')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final success = await _authService.loginPos(email, password);
      
      if (success && mounted) {
        // Jika berhasil, navigasi ke halaman POS
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.userPosProduct,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const panelColor = Color(0xFFBFE9FF);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final maxWidth = c.maxWidth > 430 ? 430.0 : c.maxWidth;

            return Center(
              child: SizedBox(
                width: maxWidth,
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Logo
                    SizedBox(
                      height: 54,
                      child: Image.asset(
                        logoPath,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Text(
                          'Tumbuhin\nPOS Management',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0EA5E9),
                            height: 1.05,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Ilustrasi
                    SizedBox(
                      height: size.height * 0.25,
                      child: Image.asset(
                        heroPath,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Tagline
                    const Text(
                      'Imagine Optimizing Your Business...\nAutomatically.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        color: Color(0xFF374151),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Dots indicator
                    const _DotsIndicator(activeIndex: 1, count: 3),

                    const SizedBox(height: 12),

                    // Panel
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: panelColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'login to',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'User Dashboard',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Email
                              _InputField(
                                controller: emailC,
                                hintText: 'E-mail',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              const SizedBox(height: 12),

                              // Password
                              _InputField(
                                controller: passC,
                                hintText: 'Password',
                                prefixIcon: Icons.lock_outline,
                                obscureText: obscure,
                                suffix: IconButton(
                                  onPressed: () =>
                                      setState(() => obscure = !obscure),
                                  icon: Icon(
                                    obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberMe,
                                    onChanged: (v) =>
                                        setState(() => rememberMe = v ?? false),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: const VisualDensity(
                                      horizontal: -4,
                                      vertical: -4,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Remember me',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      debugPrint('Forget Password');
                                    },
                                    child: const Text(
                                      'Forget Password?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF1F2937),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _handleLogin, 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3B82F6),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: isLoading 
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),

                              const Spacer(),

                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.lock,
                                          size: 14, color: Color(0xFF6B7280)),
                                      SizedBox(width: 6),
                                      Text(
                                        'possystem.com',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6B7280),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int activeIndex;
  final int count;

  const _DotsIndicator({required this.activeIndex, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF3B82F6) : const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFF6B7280)),
          suffixIcon: suffix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF93C5FD)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
