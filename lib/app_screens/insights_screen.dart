import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/date_formatters.dart';
import '../models/warranty_item.dart';
import '../state/warranty_store.dart';
import '../widgets/app_widgets.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({required this.store, super.key});

  final WarrantyStore store;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final active = store.activeCountAt(now);
    final expiring = store.expiringCountAt(now);
    final expired = store.expiredCountAt(now);
    final total = store.warranties.length;
    final withReceipt =
        store.warranties.where((item) => item.receiptFileName.isNotEmpty).length;
    final protectionScore = total == 0
        ? 0
        : (((active + expiring) / total) * 70 +
                (withReceipt / total) * 30)
            .round();

    final categories = <String, double>{};
    for (final item in store.warranties) {
      categories.update(
        item.category,
        (value) => value + item.price,
        ifAbsent: () => item.price,
      );
    }
    final categoryEntries = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxCategoryValue = categoryEntries.isEmpty
        ? 1.0
        : categoryEntries.first.value;

    return AppPageBackground(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 112),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Protection insights',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.7,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A clear view of your coverage and purchase value',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 23),
                    GlassCard(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 480;
                          final chart = SizedBox.square(
                            dimension: compact ? 175 : 200,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: Size.square(compact ? 175 : 200),
                                  painter: _WarrantyDonutPainter(
                                    active: active,
                                    expiring: expiring,
                                    expired: expired,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$total',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      'warranties',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                          final legend = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Coverage status',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 16),
                              _LegendItem(
                                color: AppColors.success,
                                label: 'Active',
                                value: active,
                              ),
                              _LegendItem(
                                color: AppColors.warning,
                                label: 'Expiring soon',
                                value: expiring,
                              ),
                              _LegendItem(
                                color: AppColors.danger,
                                label: 'Expired',
                                value: expired,
                              ),
                            ],
                          );
                          if (compact) {
                            return Column(
                              children: [
                                chart,
                                const SizedBox(height: 20),
                                legend,
                              ],
                            );
                          }
                          return Row(
                            children: [
                              chart,
                              const SizedBox(width: 28),
                              Expanded(child: legend),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.euro_rounded,
                            label: 'Protected value',
                            value: formatMoney(
                              store.protectedValue,
                              store.currency,
                            ),
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.health_and_safety_outlined,
                            label: 'Protection score',
                            value: '$protectionScore%',
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 27),
                    const AppSectionHeader(title: 'Value by category'),
                    const SizedBox(height: 12),
                    GlassCard(
                      child: categoryEntries.isEmpty
                          ? const EmptyState(
                              icon: Icons.bar_chart_rounded,
                              title: 'No data yet',
                              message: 'Add warranties to see category insights.',
                            )
                          : Column(
                              children: categoryEntries
                                  .take(6)
                                  .map(
                                    (entry) => _CategoryBar(
                                      category: entry.key,
                                      value: entry.value,
                                      maxValue: maxCategoryValue,
                                      currency: store.currency,
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                    const SizedBox(height: 27),
                    const AppSectionHeader(title: 'Vault quality'),
                    const SizedBox(height: 12),
                    GlassCard(
                      child: Column(
                        children: [
                          _QualityRow(
                            icon: Icons.receipt_long_outlined,
                            title: 'Receipts attached',
                            value: '$withReceipt of $total',
                            progress: total == 0 ? 0 : withReceipt / total,
                          ),
                          const SizedBox(height: 20),
                          _QualityRow(
                            icon: Icons.qr_code_2_rounded,
                            title: 'Serial numbers saved',
                            value:
                                '${store.warranties.where((item) => item.serialNumber.isNotEmpty).length} of $total',
                            progress: total == 0
                                ? 0
                                : store.warranties
                                        .where(
                                          (item) => item.serialNumber.isNotEmpty,
                                        )
                                        .length /
                                    total,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarrantyDonutPainter extends CustomPainter {
  const _WarrantyDonutPainter({
    required this.active,
    required this.expiring,
    required this.expired,
  });

  final int active;
  final int expiring;
  final int expired;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.39;
    final backgroundPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.32)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 17;
    canvas.drawCircle(center, radius, backgroundPaint);

    final total = active + expiring + expired;
    if (total == 0) return;
    final values = [active, expiring, expired];
    final colors = [AppColors.success, AppColors.warning, AppColors.danger];
    var start = -math.pi / 2;
    const gap = 0.07;

    for (var index = 0; index < values.length; index++) {
      if (values[index] == 0) continue;
      final sweep = values[index] / total * math.pi * 2;
      final paint = Paint()
        ..color = colors[index]
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 17;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start + gap / 2,
        math.max(0.0, sweep - gap),
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _WarrantyDonutPainter oldDelegate) =>
      active != oldDelegate.active ||
      expiring != oldDelegate.expiring ||
      expired != oldDelegate.expired;
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Text(
            '$value',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(height: 13),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.category,
    required this.value,
    required this.maxValue,
    required this.currency,
  });

  final String category;
  final double value;
  final double maxValue;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(categoryIcon(category), size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                formatMoney(value, currency),
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value / maxValue,
              minHeight: 7,
              backgroundColor: AppColors.border.withValues(alpha: 0.35),
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }
}

class _QualityRow extends StatelessWidget {
  const _QualityRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.progress,
  });

  final IconData icon;
  final String title;
  final String value;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: AppColors.primary, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.border.withValues(alpha: 0.35),
                  valueColor: const AlwaysStoppedAnimation(AppColors.success),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
