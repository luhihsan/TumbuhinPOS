import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:pos_project_app/features/user/models/product.dart';

enum PaymentMethod { cash, qris, online }

class OrderPanel extends StatefulWidget {
  // ====== data order ======
  final List<OrderItemDraft> items;
  final void Function(int index) onRemoveAt;

  // ====== bill management ======
  final VoidCallback onNewBill;
  final VoidCallback onOpenBills;

  // ====== payment state from parent ======
  final bool isPaymentMode;
  final String customerName;

  // ====== payment events ======
  final void Function(String customerName) onStartPayment; // setelah input nama
  final VoidCallback onBackToOrder; // cancel payment
  final VoidCallback onConfirmPaid; // confirm payment (UI)

  const OrderPanel({
    super.key,
    required this.items,
    required this.onRemoveAt,
    required this.onNewBill,
    required this.onOpenBills,
    required this.isPaymentMode,
    required this.customerName,
    required this.onStartPayment,
    required this.onBackToOrder,
    required this.onConfirmPaid,
  });

  @override
  State<OrderPanel> createState() => _OrderPanelState();
}

class _OrderPanelState extends State<OrderPanel> {
  final _rupiah = NumberFormat.decimalPattern('id_ID');

  PaymentMethod method = PaymentMethod.cash;

  // cash state
  int paidAmount = 0;
  final TextEditingController customPayC = TextEditingController();

  @override
  void dispose() {
    customPayC.dispose();
    super.dispose();
  }

  int get subtotal => widget.items.fold(0, (sum, i) => sum + i.lineTotal);
  int get tax => 0;
  int get total => subtotal + tax;

  int get change => (paidAmount - total) > 0 ? (paidAmount - total) : 0;

  bool get cashEnough => paidAmount >= total && total > 0;

  String rp(int n) => 'Rp ${_rupiah.format(n)}';

  List<int> _cashSuggestions(int total) {
    if (total <= 0) return const [];

    // pecahan umum IDR (bisa kamu tambah)
    const denoms = <int>[
      1000,
      2000,
      5000,
      10000,
      20000,
      50000,
      100000,
      200000,
      500000,
      1000000,
    ];

    final out = <int>{};

    // 1) uang pas (total)
    out.add(total);

    // 2) pecahan terdekat di atas total (1-2 pilihan)
    for (final d in denoms) {
      if (d >= total) {
        out.add(d);
      }
      if (out.length >= 3) break; // total + 2 pilihan
    }

    // Kalau total > 1jt, tetap kasih “dibulatkan ke atas” 10rb/50rb
    if (out.length < 3) {
      int rounded = ((total + 9999) ~/ 10000) * 10000;
      out.add(rounded);
      rounded = ((total + 49999) ~/ 50000) * 50000;
      out.add(rounded);
    }

    final list = out.toList()..sort();
    return list.take(3).toList();
  }

  Future<void> _askCustomerNameThenStartPayment() async {
    final c = TextEditingController(text: widget.customerName);
    final name = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: SizedBox(
            width: 720,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      const Text(
                        'Customer Name',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: c,
                    decoration: InputDecoration(
                      hintText: 'Add Name...',
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
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
                        borderSide: const BorderSide(color: Color(0xFF60A5FA)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final v = c.text.trim();
                        Navigator.pop(context, v.isEmpty ? 'Guest' : v);
                      },
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (name == null) return;

    // reset state cash tiap masuk payment
    setState(() {
      method = PaymentMethod.cash;
      paidAmount = 0;
      customPayC.text = '';
    });

    widget.onStartPayment(name);
  }

  Widget _headerOrder() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            // bill management dialog kamu sudah ada di file lama? tetap pakai milikmu.
            widget.onOpenBills();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Icon(Icons.receipt_long, color: Color(0xFF9CA3AF)),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Order Number: #003',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _headerPayment() {
    return Row(
      children: [
        IconButton(
          onPressed: widget.onBackToOrder,
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'Order Payment',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: widget.onBackToOrder,
          icon: const Icon(Icons.close),
          tooltip: 'Close',
        ),
      ],
    );
  }

  Widget _methodCard({
    required PaymentMethod m,
    required String label,
    required IconData icon,
  }) {
    final active = method == m;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            method = m;
            // reset cash input kalau ganti method
            paidAmount = 0;
            customPayC.text = '';
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 92,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFEFF6FF) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active ? const Color(0xFF60A5FA) : const Color(0xFFE5E7EB),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cashSection() {
    final sugg = _cashSuggestions(total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text('Input Amount', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),

        // quick buttons
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: sugg.map((amt) {
            final active = paidAmount == amt;
            return SizedBox(
              width: 160,
              height: 52,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: active ? const Color(0xFF0EA5E9) : Colors.white,
                  foregroundColor: active ? Colors.white : const Color(0xFF111827),
                  side: BorderSide(
                    color: active ? const Color(0xFF0EA5E9) : const Color(0xFFE5E7EB),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    paidAmount = amt;
                    customPayC.text = _rupiah.format(amt);
                  });
                },
                child: Text(rp(amt), style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 14),

        // custom input
        TextField(
          controller: customPayC,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (v) {
            final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
            final n = int.tryParse(digits) ?? 0;
            setState(() => paidAmount = n);
          },
          decoration: InputDecoration(
            prefixText: 'Rp ',
            hintText: '0',
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
              borderSide: const BorderSide(color: Color(0xFF60A5FA)),
            ),
          ),
        ),

        const SizedBox(height: 10),

        if (paidAmount > 0)
          Text(
            paidAmount >= total ? 'Change: ${rp(change)}' : 'Kurang: ${rp(total - paidAmount)}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: paidAmount >= total ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
            ),
          ),
      ],
    );
  }

  Widget _paymentBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer: ${widget.customerName}', style: const TextStyle(color: Color(0xFF6B7280))),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Subtotal'),
                  const Spacer(),
                  Text(rp(subtotal), style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text('Tax (0%)'),
                  const Spacer(),
                  Text(rp(tax), style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              const Divider(height: 18),
              Row(
                children: [
                  const Text('Total', style: TextStyle(fontWeight: FontWeight.w900)),
                  const Spacer(),
                  Text(rp(total),
                      style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0EA5E9))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),

        Row(
          children: [
            _methodCard(m: PaymentMethod.cash, label: 'Cash', icon: Icons.payments_outlined),
            const SizedBox(width: 12),
            _methodCard(m: PaymentMethod.qris, label: 'QRIS', icon: Icons.qr_code_2),
            const SizedBox(width: 12),
            _methodCard(m: PaymentMethod.online, label: 'Online', icon: Icons.delivery_dining),
          ],
        ),

        if (method == PaymentMethod.cash) _cashSection(),

        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: method == PaymentMethod.cash ? (cashEnough ? widget.onConfirmPaid : null) : widget.onConfirmPaid,
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: const Color(0xFF9CA3AF),
              disabledForegroundColor: const Color(0xFFE5E7EB),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Confirm Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          ),
        ),
      ],
    );
  }

  Widget _orderBody() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: 'Dine In',
          items: const [
            DropdownMenuItem(value: 'Dine In', child: Text('Dine In')),
            DropdownMenuItem(value: 'Take Away', child: Text('Take Away')),
          ],
          onChanged: (_) {},
          decoration: const InputDecoration(
            labelText: 'Order Type',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(),

        if (widget.items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Text('No Item Selected', style: TextStyle(color: Color(0xFF6B7280))),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.items.length,
            separatorBuilder: (_, __) => const Divider(height: 18),
            itemBuilder: (context, i) {
              final it = widget.items[i];
              final type = it.orderType == OrderType.dineIn ? 'Dine In' : 'Take Away';

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Icon(Icons.restaurant, color: Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${it.qty}x ${it.product.name}',
                            style: const TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('$type • ${rp(it.price)}',
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w600,
                            )),
                        if (it.note.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text('Note: ${it.note}'),
                        ],
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => widget.onRemoveAt(i),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: const Icon(Icons.delete_outline),
                    ),
                  ),
                ],
              );
            },
          ),

        const Divider(),

        Row(
          children: [
            const Text('Subtotal', style: TextStyle(color: Color(0xFF6B7280))),
            const Spacer(),
            Text(rp(subtotal), style: const TextStyle(color: Color(0xFF6B7280))),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text('Tax 0%', style: TextStyle(color: Color(0xFF6B7280))),
            const Spacer(),
            Text(rp(tax), style: const TextStyle(color: Color(0xFF6B7280))),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(height: 18),
        Row(
          children: [
            const Text('Total', style: TextStyle(fontWeight: FontWeight.w900)),
            const Spacer(),
            Text(rp(total), style: const TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Panel kanan harus aman overflow: middle scroll, footer fixed
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          widget.isPaymentMode ? _headerPayment() : _headerOrder(),
          const SizedBox(height: 12),

          Expanded(
            child: SingleChildScrollView(
              child: widget.isPaymentMode ? _paymentBody() : _orderBody(),
            ),
          ),

          const SizedBox(height: 12),

          // footer untuk ORDER mode: tombol Charge
          if (!widget.isPaymentMode)
            SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: total <= 0 ? null : _askCustomerNameThenStartPayment,
                  child: Text('Charge ${rp(total)}'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
