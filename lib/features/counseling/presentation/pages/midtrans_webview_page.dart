import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:temanmu/features/counseling/domain/entities/payment.dart';
import 'package:temanmu/services/toast_service.dart';
import 'package:temanmu/services/router_service.dart';

class MidtransWebViewPage extends StatefulWidget {
  final Payment payment;
  final Function(Payment) onPaymentComplete;

  const MidtransWebViewPage({
    super.key,
    required this.payment,
    required this.onPaymentComplete,
  });

  @override
  State<MidtransWebViewPage> createState() => _MidtransWebViewPageState();
}

class _MidtransWebViewPageState extends State<MidtransWebViewPage> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading progress
              },
              onPageStarted: (String url) {
                if (mounted) {
                  setState(() {
                    isLoading = true;
                  });
                }
              },
              onPageFinished: (String url) {
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              onWebResourceError: (WebResourceError error) {
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                  ToastService.show(
                    context,
                    'Terjadi kesalahan WebView: ${error.description}',
                  );
                }
              },
              onNavigationRequest: (NavigationRequest request) {
                // Handle navigation events
                final url = request.url.toLowerCase();

                // Check for payment completion URLs
                if (url.contains('success') ||
                    url.contains('finish') ||
                    url.contains('settlement') ||
                    url.contains('capture') ||
                    url.contains('payment_success')) {
                  // Close WebView first
                  Navigator.of(context).pop();
                  // Then trigger payment completion
                  widget.onPaymentComplete(widget.payment);
                  return NavigationDecision.prevent;
                }

                // Check for failure URLs
                if (url.contains('error') ||
                    url.contains('cancel') ||
                    url.contains('failure')) {
                  Navigator.of(context).pop();
                  ToastService.show(
                    context,
                    'Pembayaran dibatalkan atau gagal',
                  );
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.payment.redirectUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Allow user to exit payment page without blocking future bookings
            // The pending payment will be handled by the backend
            Navigator.of(context).pop();
            router.pop(); // Also pop the payment page
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'browser') {
                await _openInBrowser();
              } else if (value == 'refresh') {
                _controller.reload();
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'refresh',
                    child: Row(
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 8),
                        Text('Refresh'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'browser',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_browser),
                        SizedBox(width: 8),
                        Text('Open in Browser'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF51A2FF),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading payment page...',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openInBrowser() async {
    try {
      final uri = Uri.parse(widget.payment.redirectUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        Navigator.of(context).pop();
      } else {
        ToastService.show(context, 'Tidak dapat membuka halaman pembayaran');
      }
    } catch (e) {
      ToastService.show(context, 'Gagal membuka browser: $e');
    }
  }
}
