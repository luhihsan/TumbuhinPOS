import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const ListTile(
              title: Text(
                'Tumbuhin\nPOS Management',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: const [
                  _DrawerItem(icon: Icons.storefront, label: 'POS Product'),
                  _DrawerItem(icon: Icons.history, label: 'Activity'),
                  _DrawerItem(icon: Icons.event_available, label: 'Absence'),
                  _DrawerItem(icon: Icons.local_shipping, label: 'Consignment'),
                  Divider(),
                  _DrawerItem(icon: Icons.inventory_2, label: 'Inventory'),
                  _DrawerItem(icon: Icons.groups, label: 'Shift'),
                  Divider(),
                  _DrawerItem(icon: Icons.logout, label: 'Log Out'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Need help?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Email Our Support Team!',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0EA5E9),
                        ),
                        onPressed: () {},
                        child: const Text('Email us'),
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
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DrawerItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF374151)),
      title: Text(label),
      onTap: () {
        Navigator.pop(context); // tutup drawer dulu
        // TODO: nanti routing ke page terkait
      },
    );
  }
}
