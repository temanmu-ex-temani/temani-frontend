import 'package:flutter/material.dart';
import 'package:temanmu/features/counseling/domain/entities/payment.dart';
import 'package:temanmu/features/counseling/domain/repositories/payment_repository.dart';
import 'package:get_it/get_it.dart';

class PaymentProcessingDialog extends StatefulWidget {
  final Payment payment;
  final VoidCallback onBackPressed;

  const PaymentProcessingDialog({
    super.key,
    required this.payment,
    required this.onBackPressed,
  });

  @override
  State<PaymentProcessingDialog> createState() =>
      _PaymentProcessingDialogState();
}

class _PaymentProcessingDialogState extends State<PaymentProcessingDialog> {
  late final PaymentRepository _paymentRepository;
  bool isChecking = true;
  String statusMessage = 'Pembayaran sedang diproses';

  @override
  void initState() {
    super.initState();
    _paymentRepository = GetIt.instance<PaymentRepository>();
    // Start checking payment status after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      _checkPaymentStatus();
    });
  }

  Future<void> _checkPaymentStatus() async {
    try {
      final result = await _paymentRepository.getPaymentStatus(
        widget.payment.midtransOrderId,
      );

      result.fold(
        (failure) {
          if (mounted) {
            setState(() {
              isChecking = false;
              statusMessage = 'Gagal memverifikasi status pembayaran';
            });
          }
        },
        (paymentResponse) {
          if (mounted) {
            setState(() {
              isChecking = false;
              if (paymentResponse.isSuccessful) {
                statusMessage = 'Pembayaran berhasil!';
              } else if (paymentResponse.isPending) {
                statusMessage = 'Pembayaran masih diproses';
                // Continue checking after 5 seconds
                Future.delayed(const Duration(seconds: 5), () {
                  if (mounted) {
                    _checkPaymentStatus();
                  }
                });
              } else {
                statusMessage = 'Pembayaran gagal atau dibatalkan';
              }
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          isChecking = false;
          statusMessage = 'Terjadi kesalahan saat memverifikasi pembayaran';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Processing animation
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE0EDFF),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.payment,
                size: 40,
                color: Color(0xFF51A2FF),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              statusMessage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              isChecking
                  ? 'Mohon tunggu sebentar, pembayaran Anda sedang diproses.'
                  : 'Silakan kembali ke halaman utama.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Loading indicator (only show when checking)
            if (isChecking)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF51A2FF)),
                ),
              )
            else
              Icon(
                statusMessage.contains('berhasil')
                    ? Icons.check_circle
                    : Icons.error,
                size: 48,
                color:
                    statusMessage.contains('berhasil')
                        ? Colors.green
                        : Colors.red,
              ),
            const SizedBox(height: 24),

            // Back button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onBackPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF51A2FF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Kembali',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
