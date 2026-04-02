import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PaymentSuccessDialog extends StatelessWidget {
  final int amount;
  final int change;
  final String orderNumber;
  final String paymentMethod;
  final DateTime paymentTime;

  final VoidCallback onPrintReceipt;
  final VoidCallback onPrintKitchen;
  final VoidCallback onPrintBarista;
  final VoidCallback onNewOrder;

  const PaymentSuccessDialog({
    super.key,
    required this.amount,
    required this.change,
    required this.orderNumber,
    required this.paymentMethod,
    required this.paymentTime,
    required this.onPrintReceipt,
    required this.onPrintKitchen,
    required this.onPrintBarista,
    required this.onNewOrder,
  });

  String _rp(int n) => 'Rp ${NumberFormat.decimalPattern('id_ID').format(n)}';

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('dd/MM/yyyy, hh:mm a').format(paymentTime);

    // tinggi maksimal dialog (biar ga overflow)
    final maxH = MediaQuery.of(context).size.height * 0.88;
    final maxW = MediaQuery.of(context).size.width * 0.92;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxW.clamp(0, 760),
            maxHeight: maxH,
          ),
          child: Padding(
            // aman kalau ada keyboard/viewInsets
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              // bikin isi bisa scroll kalau kepanjangan
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // header row (close)
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    // icon (svg)
                    SvgPicture.asset(
                      'assets/payment-success.svg',
                      width: 110,
                      height: 110,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      'Payment Success',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    const Text('Amount', style: TextStyle(color: Color(0xFF6B7280))),
                    const SizedBox(height: 6),

                    Text(
                      _rp(amount),
                      style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 6),
                    Text(
                      'Change Cash ${_rp(change)}',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        children: [
                          _row('Order Number:', orderNumber),
                          const SizedBox(height: 10),
                          _row('Payment Method:', paymentMethod),
                          const SizedBox(height: 10),
                          _row('Payment Time:', timeStr),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // tombol print (wrap biar aman di layar sempit)
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: onPrintReceipt,
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Print Receipt',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: onPrintKitchen,
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Print Kitchen',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: onPrintBarista,
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Print Barista',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: onNewOrder,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'New Order',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String left, String right) {
    return Row(
      children: [
        Text(left, style: const TextStyle(color: Color(0xFF6B7280))),
        const Spacer(),
        Flexible(
          child: Text(
            right,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}
