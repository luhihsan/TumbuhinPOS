import 'package:flutter/material.dart';
import 'package:pos_project_app/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ValueChanged<OrderItemDraft> onAdd; // callback ke screen

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
  });

  Future<void> _openAddDialog(BuildContext context) async {
    final result = await showDialog<OrderItemDraft>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AddOrderDialog(product: product),
    );

    if (result != null) onAdd(result);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openAddDialog(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.fastfood),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Text(
                    'Rp ${product.price}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            const Icon(Icons.add_shopping_cart),
          ],
        ),
      ),
    );
  }
}

class _AddOrderDialog extends StatefulWidget {
  final Product product;
  const _AddOrderDialog({required this.product});

  @override
  State<_AddOrderDialog> createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends State<_AddOrderDialog> {
  late int qty;
  late OrderType orderType;
  late TextEditingController priceC;
  late TextEditingController noteC;

  @override
  void initState() {
    super.initState();
    qty = 1;
    orderType = OrderType.dineIn;
    priceC = TextEditingController(text: widget.product.price.toString());
    noteC = TextEditingController();
  }

  @override
  void dispose() {
    priceC.dispose();
    noteC.dispose();
    super.dispose();
  }

  int _parsePrice() {
    final raw = priceC.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.isEmpty) return widget.product.price;
    return int.tryParse(raw) ?? widget.product.price;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final dialogWidth = w > 720 ? 720.0 : w * 0.92;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Active'),
                        SizedBox(width: 6),
                        Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // qty + price
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // qty
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Item Quantity',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _SquareBtn(
                              icon: Icons.remove,
                              onTap:
                                  qty > 1 ? () => setState(() => qty--) : null,
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 72,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller:
                                    TextEditingController(text: qty.toString()),
                                readOnly: true,
                                decoration: _inputDeco(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _SquareBtn(
                              icon: Icons.add,
                              onTap: () => setState(() => qty++),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // price editable
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Price',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: priceC,
                          keyboardType: TextInputType.number,
                          decoration: _inputDeco(prefix: 'Rp '),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              const Text(
                'Order Type',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  _TogglePill(
                    active: orderType == OrderType.dineIn,
                    label: 'Dine In',
                    onTap: () => setState(() => orderType = OrderType.dineIn),
                  ),
                  const SizedBox(width: 12),
                  _TogglePill(
                    active: orderType == OrderType.takeAway,
                    label: 'Take Away',
                    onTap: () => setState(() => orderType = OrderType.takeAway),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              const Text(
                'Notes',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noteC,
                minLines: 3,
                maxLines: 5,
                decoration: _inputDeco(hint: 'add a note'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 140,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 140,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        final draft = OrderItemDraft(
                          product: widget.product,
                          qty: qty,
                          orderType: orderType,
                          price: _parsePrice(),
                          note: noteC.text.trim(),
                        );
                        Navigator.pop(context, draft);
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco({String? hint, String? prefix}) {
    return InputDecoration(
      hintText: hint,
      prefixText: prefix,
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF93C5FD)),
      ),
    );
  }
}

class _SquareBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _SquareBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: disabled ? const Color(0xFFF3F4F6) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Icon(
          icon,
          color: disabled ? const Color(0xFF9CA3AF) : const Color(0xFF111827),
        ),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  final bool active;
  final String label;
  final VoidCallback onTap;

  const _TogglePill({
    required this.active,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 46,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: active ? const Color(0xFF0EA5E9) : Colors.white,
            foregroundColor: active ? Colors.white : const Color(0xFF374151),
            side: BorderSide(
              color: active ? const Color(0xFF0EA5E9) : const Color(0xFFE5E7EB),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onTap,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
