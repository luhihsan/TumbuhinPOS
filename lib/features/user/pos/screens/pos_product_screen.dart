import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/dummy_products.dart';
import '../../models/product.dart';
import '../../../../core/widgets/category_chips.dart';
import '../../../../core/widgets/product_grid.dart';
import '../../../../core/widgets/order_panel.dart';
import '../../../../core/widgets/realtime_clock.dart';
import '../../navigation/user_drawer.dart';

class PosProductScreen extends StatefulWidget {
  const PosProductScreen({super.key});

  @override
  State<PosProductScreen> createState() => _PosProductScreenState();
}

class _PosProductScreenState extends State<PosProductScreen> {
  String selectedCategory = 'All Menu';
  String query = '';

  List<Product> get filteredProducts {
    final lowerQ = query.trim().toLowerCase();
    return dummyProducts.where((p) {
      final catOk = selectedCategory == 'All Menu'
          ? true
          : p.category == selectedCategory;
      final qOk = lowerQ.isEmpty
          ? true
          : (p.name.toLowerCase().contains(lowerQ) ||
              p.category.toLowerCase().contains(lowerQ));
      return catOk && qOk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = <String>[
      'All Menu',
      ...dummyCategories, // dari dummy_products.dart
    ];

    return Scaffold(
      drawer: const UserDrawer(), // hamburger -> sidebar
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Row(
          children: [
            // --- Main content (kiri besar) ---
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Top bar: hamburger + date/time + action
                    Row(
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Date (contoh: Tue, 26 Aug 2025)
                        Text(
                          DateFormat('EEE, dd MMM yyyy').format(DateTime.now()),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Real-time clock
                        const RealTimeClock(
                          format: 'hh:mm a',
                        ),

                        const Spacer(),

                        // contoh button kecil "Close Order"
                        FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text('Close Order'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Categories horizontal scroll
                    CategoryChips(
                      categories: categories,
                      selected: selectedCategory,
                      onSelected: (c) => setState(() => selectedCategory = c),
                    ),

                    const SizedBox(height: 12),

                    // Search
                    TextField(
                      onChanged: (v) => setState(() => query = v),
                      decoration: InputDecoration(
                        hintText: 'Search Something on your Product',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Grid produk (scroll)
                    Expanded(
                      child: ProductGrid(products: filteredProducts),
                    ),
                  ],
                ),
              ),
            ),

            // --- Order panel (kanan) ---
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                child: const OrderPanel(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
