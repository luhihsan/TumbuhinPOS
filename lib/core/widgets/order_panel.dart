import 'package:flutter/material.dart';

class OrderPanel extends StatelessWidget {
  const OrderPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Number: #001',
              style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
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
          const SizedBox(height: 14),
          const Divider(),
          const Spacer(),
          const Text('Total', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton(
              onPressed: () {},
              child: const Text('Charge \$0'),
            ),
          ),
        ],
      ),
    );
  }
}
