import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../widgets/app_widgets.dart';

class ReceiptScanResult {
  const ReceiptScanResult({
    required this.productName,
    required this.brand,
    required this.retailer,
    required this.price,
    required this.purchaseDate,
    required this.receiptFileName,
  });

  final String productName;
  final String brand;
  final String retailer;
  final double price;
  final DateTime purchaseDate;
  final String receiptFileName;
}

class ScanReceiptScreen extends StatefulWidget {
  const ScanReceiptScreen({super.key});

  @override
  State<ScanReceiptScreen> createState() => _ScanReceiptScreenState();
}

class _ScanReceiptScreenState extends State<ScanReceiptScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;
  bool _isScanning = false;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    setState(() {
      _isScanning = true;
      _isComplete = false;
    });
    unawaited(_scanController.repeat(reverse: true));
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    _scanController.stop();
    setState(() {
      _isScanning = false;
      _isComplete = true;
    });
  }

  void _useResult() {
    Navigator.of(context).pop(
      ReceiptScanResult(
        productName: 'MX Master 3S',
        brand: 'Logitech',
        retailer: 'Plaisio',
        price: 109.90,
        purchaseDate: DateTime.now().subtract(const Duration(days: 4)),
        receiptFileName: 'plaisio_receipt_demo.jpg',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan receipt')),
      body: AppPageBackground(
        child: SafeArea(
          top: false,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Position the receipt inside the frame',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'This portfolio build simulates OCR extraction so it works without a camera permission or external API.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 24),
                    AspectRatio(
                      aspectRatio: 0.78,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: const Color(0xFF06111E),
                          border: Border.all(
                            color: _isComplete
                                ? AppColors.success
                                : AppColors.primary.withValues(alpha: 0.65),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.16),
                              blurRadius: 25,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: const _DemoReceipt(),
                              ),
                            ),
                            if (_isScanning)
                              AnimatedBuilder(
                                animation: _scanController,
                                builder: (_, __) => Positioned(
                                  left: 22,
                                  right: 22,
                                  top: 28 +
                                      (_scanController.value *
                                          (MediaQuery.sizeOf(context).height *
                                              0.38)),
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.9),
                                          blurRadius: 13,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if (_isComplete)
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(27),
                                    color: AppColors.success.withValues(alpha: 0.08),
                                  ),
                                  child: const Center(
                                    child: CircleAvatar(
                                      radius: 31,
                                      backgroundColor: AppColors.success,
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: Color(0xFF00251D),
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    if (_isComplete) ...[
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 9),
                                Text(
                                  '5 fields extracted',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            const _ResultRow(label: 'Store', value: 'Plaisio'),
                            const _ResultRow(
                              label: 'Product',
                              value: 'Logitech MX Master 3S',
                            ),
                            const _ResultRow(label: 'Total', value: '€109.90'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _useResult,
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Use extracted details'),
                      ),
                    ] else
                      ElevatedButton.icon(
                        onPressed: _isScanning ? null : _scan,
                        icon: _isScanning
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(strokeWidth: 2.2),
                              )
                            : const Icon(Icons.document_scanner_outlined),
                        label: Text(
                          _isScanning ? 'Reading receipt…' : 'Start demo scan',
                        ),
                      ),
                    const SizedBox(height: 11),
                    OutlinedButton.icon(
                      onPressed: _isScanning
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Enter details manually'),
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
}

class _DemoReceipt extends StatelessWidget {
  const _DemoReceipt();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF2F0EA),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.38),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.storefront_rounded, color: Color(0xFF20242B), size: 34),
          const SizedBox(height: 8),
          Text(
            'PLAISIO',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF20242B),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 22),
          ...List.generate(
            4,
            (index) => Container(
              height: 6,
              margin: const EdgeInsets.only(bottom: 11),
              width: index.isEven ? double.infinity : 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xFF5A5C60).withValues(alpha: 0.45),
              ),
            ),
          ),
          const Spacer(),
          const Divider(color: Color(0xFF595A5C)),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL', style: TextStyle(color: Color(0xFF20242B))),
              Text(
                '€109.90',
                style: TextStyle(
                  color: Color(0xFF20242B),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              22,
              (index) => Container(
                width: index % 3 == 0 ? 3 : 1,
                height: 35,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                color: const Color(0xFF20242B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
