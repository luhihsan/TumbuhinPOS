import 'package:flutter/material.dart';
import 'package:pos_project_app/features/user/models/product.dart';
import 'package:pos_project_app/core/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final crossAxisCount = w > 900 ? 4 : w > 650 ? 3 : 2;

        return GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.65,
          ),
          itemBuilder: (context, i) => ProductCard(product: products[i]),
        );
      },
    );
  }
}
