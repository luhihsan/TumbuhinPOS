import 'package:flutter/material.dart';

class BillManagementDialog extends StatelessWidget {
  final VoidCallback onNewBill;

  const BillManagementDialog({
    super.key,
    required this.onNewBill,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 800,
        height: 520,
        child: Column(
          children: [
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const Spacer(),
                  const Text(
                    'Bill Management',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onNewBill();
                    },
                    child: const Text('New Bill'),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ===== SEARCH =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search name on bill management',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            // ===== LIST (dummy UI dulu) =====
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: 6,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Test Customer (${index + 1})'),
                    trailing: const Text(
                      '6 days',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      // nanti: restore bill
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
