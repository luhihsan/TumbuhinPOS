import 'package:flutter/material.dart';
import '/features/user/navigation/user_drawer.dart';

class ConsignmentScreen extends StatefulWidget {
  const ConsignmentScreen({super.key});

  @override
  State<ConsignmentScreen> createState() => _ConsignmentScreenState();
}

class _ConsignmentScreenState extends State<ConsignmentScreen> {
  // Variable untuk melacak tab yang aktif
  // 0 = Item List, 1 = Supplier
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0EA5E9);
    const Color inactiveBlue = Color(0xFF7DD3FC);
    const Color bgGrey = Color(0xFFF3F4F6);

    return Scaffold(
      backgroundColor: bgGrey,
      drawer: const UserDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Builder(
                    builder: (context) {
                      return InkWell(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.menu, color: primaryBlue),
                        ),
                      );
                    }
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Consignment',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      Text(
                        'Daily Report Item',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // --- 2. TABS & BUTTON ADD QTY ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Custom Tabs
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TAB: ITEM LIST
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = 0;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Item List',
                              style: TextStyle(
                                color: _selectedTabIndex == 0 ? primaryBlue : inactiveBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Garis bawah aktif/non-aktif
                            Container(
                              height: 3,
                              width: 65,
                              color: _selectedTabIndex == 0 ? primaryBlue : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      
                      // TAB: SUPPLIER
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = 1;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Supplier',
                              style: TextStyle(
                                color: _selectedTabIndex == 1 ? primaryBlue : inactiveBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Garis bawah aktif/non-aktif
                            Container(
                              height: 3,
                              width: 60,
                              color: _selectedTabIndex == 1 ? primaryBlue : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Button Add Qty (Hanya muncul jika _selectedTabIndex == 0)
                  if (_selectedTabIndex == 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Action tambah qty
                        },
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Add Qty'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryBlue,
                          side: const BorderSide(color: primaryBlue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    )
                  else 
                    const SizedBox(height: 48), 
                ],
              ),
              
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedTabIndex == 0 
                  ? _buildItemListHeader() 
                  : _buildSupplierHeader(),
              ),
              
              // --- 4. DATA LIST (Nanti diisi ListView) ---
              // Expanded(
              //   child: _selectedTabIndex == 0 
              //       ? ListView(...) // List untuk Item List
              //       : ListView(...), // List untuk Supplier
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemListHeader() {
    return const Row(
      children: [
        Expanded(flex: 3, child: Text('Item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        Expanded(flex: 2, child: Text('Supplier', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        Expanded(flex: 2, child: Text('Stock In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        Expanded(flex: 1, child: Text('Sold', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        Expanded(flex: 2, child: Text('Remaining', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildSupplierHeader() {
    return const Row(
      children: [
        Expanded(flex: 3, child: Text('Supplier name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        Expanded(flex: 2, child: Text('Sold item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        Expanded(flex: 2, child: Text('Remaining', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        Expanded(flex: 2, child: Text('Price Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        Expanded(flex: 1, child: Text('Action', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ],
    );
  }
}