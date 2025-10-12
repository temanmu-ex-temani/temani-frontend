import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final List<Map<String, dynamic>> methods;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  const PaymentMethodSelector({
    super.key,
    required this.methods,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih metode pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),
          ...List.generate(methods.length, (i) {
            final selected = i == selectedIndex;
            return GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: selected ? Color(0xFFE0EDFF) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? Color(0xFF51A2FF) : Colors.grey.shade200,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      methods[i]['icon'],
                      color: selected ? Color(0xFF51A2FF) : Colors.black54,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      methods[i]['label'],
                      style: TextStyle(
                        color: selected ? Color(0xFF51A2FF) : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
