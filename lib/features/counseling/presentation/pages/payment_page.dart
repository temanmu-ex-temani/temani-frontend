import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:temanmu/features/counseling/domain/entities/counseling_schedule.dart';
import 'package:temanmu/features/counseling/presentation/widgets/payment_header.dart';
import 'package:temanmu/features/counseling/presentation/widgets/payment_selected_session_card.dart';
import 'package:temanmu/features/counseling/presentation/widgets/payment_summary.dart';
import 'package:temanmu/features/counseling/presentation/widgets/payment_pay_button.dart';
import 'package:temanmu/features/counseling/domain/repositories/payment_repository.dart';
import 'package:temanmu/features/counseling/domain/entities/payment.dart';
import 'package:temanmu/features/counseling/domain/entities/payment_request.dart';
import 'package:temanmu/features/counseling/presentation/pages/midtrans_webview_page.dart';
import 'package:temanmu/services/router_service.dart';
import 'package:get_it/get_it.dart';
import 'package:temanmu/services/toast_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  CounselingSchedule? selectedSchedule;
  bool isLoading = false;
  late final PaymentRepository _paymentRepository;

  @override
  void initState() {
    super.initState();
    _paymentRepository = GetIt.instance<PaymentRepository>();
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

  Future<void> _handlePayment() async {
    if (selectedSchedule == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final request = PaymentRequest(
        scheduleId: selectedSchedule!.id,
        fee: 35000, // Fixed fee as per your example
      );

      final result = await _paymentRepository.createPayment(request);

      result.fold(
        (failure) {
          setState(() {
            isLoading = false;
          });
          // If payment creation fails due to pending payment or other reasons,
          // allow user to proceed anyway - remove the restriction
          // Just show a warning but don't block them
          if (failure.message.toLowerCase().contains('pending') ||
              failure.message.toLowerCase().contains('already')) {
            ToastService.show(
              context,
              'Pembayaran sebelumnya terdeteksi. Silakan coba lagi.',
            );
          } else {
            ToastService.show(
              context,
              'Pembayaran gagal: ${failure.message}',
            );
          }
        },
        (payment) {
          setState(() {
            isLoading = false;
          });
          _openMidtransWebView(payment);
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ToastService.show(context, 'Terjadi kesalahan pembayaran: $e');
    }
  }

  void _openMidtransWebView(Payment payment) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => MidtransWebViewPage(
              payment: payment,
              onPaymentComplete: _handlePaymentComplete,
            ),
      ),
    );
  }

  void _handlePaymentComplete(Payment payment) {
    _showPaymentSuccessDialog(payment);
  }

  void _showPaymentSuccessDialog(Payment payment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 16,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.grey.shade50],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success Animation Container
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Payment Successful!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'Your payment has been processed successfully.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Payment Details Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Color(0xFF51A2FF),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Payment Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Amount Row
                        _buildDetailRow(
                          icon: Icons.account_balance_wallet,
                          label: 'Amount',
                          value: payment.formattedAmount,
                          isHighlight: true,
                        ),
                        const SizedBox(height: 16),

                        // Status Row
                        _buildDetailRow(
                          icon: Icons.check_circle_outline,
                          label: 'Status',
                          value: payment.status,
                          isSuccess: true,
                        ),
                        const SizedBox(height: 16),

                        // Order ID Row
                        _buildDetailRow(
                          icon: Icons.receipt_long,
                          label: 'Order ID',
                          value: payment.midtransOrderId,
                          isLong: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Continue Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF51A2FF), Color(0xFF00D3F3)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF51A2FF).withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        router.go('/main');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Continue to Dashboard',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlight = false,
    bool isSuccess = false,
    bool isLong = false,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color:
                isSuccess
                    ? Colors.green.shade50
                    : isHighlight
                    ? Color(0xFF51A2FF).withOpacity(0.1)
                    : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color:
                isSuccess
                    ? Colors.green.shade600
                    : isHighlight
                    ? Color(0xFF51A2FF)
                    : Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isLong ? 12 : 14,
                  fontWeight: FontWeight.bold,
                  color:
                      isHighlight
                          ? Color(0xFF51A2FF)
                          : isSuccess
                          ? Colors.green.shade600
                          : Colors.grey.shade800,
                ),
                overflow: isLong ? TextOverflow.ellipsis : null,
              ),
            ],
          ),
        ),
      ],
    );
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
                  PaymentSummary(schedule: selectedSchedule),
                  const SizedBox(height: 24),
                  PaymentPayButton(
                    enabled: !isLoading && selectedSchedule != null,
                    onPressed: _handlePayment,
                    isLoading: isLoading,
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
