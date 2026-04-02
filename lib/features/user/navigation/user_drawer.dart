import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // --- 1. HEADER ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/logo-tumbuhin-drawer.png',
                  height: 48, 
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // --- 2. LIST MENU DENGAN KATEGORI ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Kategori: OPERATIONS
                  _buildSectionTitle('OPERATIONS'),
                  _DrawerItem(
                    icon: Icons.monitor_outlined, 
                    label: 'POS Product',
                    routeName: AppRoutes.userPosProduct,
                    currentRoute: currentRoute,
                  ),
                  _DrawerItem(
                    icon: Icons.description_outlined,
                    label: 'Activity',
                    currentRoute: currentRoute,
                  ),
                  _DrawerItem(
                    icon: Icons.badge_outlined,
                    label: 'Absence',
                    currentRoute: currentRoute,
                  ),
                  _DrawerItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Consignment',
                    routeName: AppRoutes.userConsignment,
                    currentRoute: currentRoute,
                  ),
                  
                  // Garis Pemisah
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: Divider(color: Color(0xFFE5E7EB)),
                  ),

                  // Kategori: BUSINESS MANAGEMENT
                  _buildSectionTitle('BUSINESS MANAGEMENT'),
                  _DrawerItem(
                    icon: Icons.format_list_bulleted,
                    label: 'Inventory',
                    currentRoute: currentRoute,
                  ),
                  _DrawerItem(
                    icon: Icons.assignment_outlined,
                    label: 'Shift',
                    currentRoute: currentRoute,
                  ),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    currentRoute: currentRoute,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Menu Logout 
                  _DrawerItem(
                    icon: Icons.logout,
                    label: 'Log Out',
                    currentRoute: currentRoute,
                    isDestructive: true,
                    onTapOverride: () {
                      // TODO: Clear session/token di sini
                      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
                    },
                  ),
                ],
              ),
            ),

            // --- 3. BOTTOM HELP BANNER (Sesuai Web) ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF8FF), // Biru pudar banget ala web
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Need help?',
                      style: TextStyle(
                        color: Color(0xFF0EA5E9),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Email Our Support Team!',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0EA5E9), // Biru Solid
                          foregroundColor: Colors.white,
                          elevation: 0, // Datar biar mirip desain web
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Email us', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget (OPERATIONS / BUSINESS MANAGEMENT)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF9CA3AF), 
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? routeName;
  final String? currentRoute;
  final bool isDestructive;
  final VoidCallback? onTapOverride;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.routeName,
    this.currentRoute,
    this.isDestructive = false,
    this.onTapOverride,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentRoute == routeName && routeName != null;
    final Color itemColor = isSelected 
        ? Colors.white 
        : (isDestructive ? const Color(0xFFEF4444) : const Color(0xFF4B5563));
    final Color bgColor = isSelected ? const Color(0xFF0EA5E9) : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTapOverride ?? () {
            Navigator.pop(context); 

            if (routeName != null && !isSelected) {
              Navigator.pushReplacementNamed(context, routeName!);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8), 
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: itemColor, size: 22),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: itemColor,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}