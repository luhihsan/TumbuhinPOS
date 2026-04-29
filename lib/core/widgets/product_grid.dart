import 'package:flutter/material.dart';
import 'package:pos_project_app/models/product_model.dart';
import 'package:pos_project_app/core/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<OrderItemDraft> onAdd;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final crossAxisCount = w > 900
            ? 4
            : w > 650
                ? 3
                : 2;

        return GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.65,
          ),
          itemBuilder: (context, i) => ProductCard(
            product: products[i],
            onAdd: onAdd,
          ),
        );
      },
    );
  }
}
