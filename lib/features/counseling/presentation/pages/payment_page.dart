import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:temani_frontend/features/counseling/domain/entities/counseling_schedule.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/payment_header.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/payment_selected_session_card.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/payment_method_selector.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/payment_summary.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/payment_pay_button.dart';
import 'package:temani_frontend/services/router_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedMethod = 0;
  CounselingSchedule? selectedSchedule;

  final List<Map<String, dynamic>> paymentMethods = [
    {'label': 'Credit Card', 'icon': Icons.credit_card},
    {'label': 'Bank Transfer', 'icon': Icons.account_balance},
    {'label': 'E-Wallet', 'icon': Icons.payment},
    {'label': 'QRIS', 'icon': Icons.qr_code},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get selected schedule from navigation extra
    if (selectedSchedule == null) {
      final extra = GoRouterState.of(context).extra;
      if (extra is CounselingSchedule) {
        setState(() {
          selectedSchedule = extra;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0.00, 1.00),
            colors: [Color(0xFFEFF6FF), Color(0xFFECFEFF), Color(0xFFECFDF5)],
            stops: [0, 0.5, 1],
            transform: GradientRotation(169 * 3.14159 / 180),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PaymentHeader(),
                  const SizedBox(height: 16),
                  PaymentSelectedSessionCard(schedule: selectedSchedule),
                  const SizedBox(height: 16),
                  PaymentMethodSelector(
                    methods: paymentMethods,
                    selectedIndex: selectedMethod,
                    onSelect: (i) => setState(() => selectedMethod = i),
                  ),
                  const SizedBox(height: 16),
                  PaymentSummary(schedule: selectedSchedule),
                  const SizedBox(height: 24),
                  PaymentPayButton(
                    enabled: true,
                    onPressed: () => router.go('/main'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
