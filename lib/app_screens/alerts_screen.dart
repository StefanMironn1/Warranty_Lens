import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/date_formatters.dart';
import '../models/warranty_item.dart';
import '../state/warranty_store.dart';
import '../widgets/app_widgets.dart';
import 'warranty_details_screen.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({required this.store, super.key});

  final WarrantyStore store;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final now = DateTime.now();
        final urgent = store.warranties
            .where(
              (item) => item.statusAt(now) != WarrantyStatus.active,
            )
            .toList();
        final upcoming = store.warranties
            .where(
              (item) => item.statusAt(now) == WarrantyStatus.active,
            )
            .take(3)
            .toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Expiry alerts')),
          body: AppPageBackground(
            child: SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!store.notificationsEnabled) ...[
                            GlassCard(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.notifications_off_outlined,
                                    color: AppColors.warning,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Expiry notifications are currently disabled in Settings.',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => store.updateSettings(
                                      enableNotifications: true,
                                    ),
                                    child: const Text('Enable'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 22),
                          ],
                          Text(
                            'Never miss the claim window',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'WarrantyLens checks your saved coverage dates and keeps the most important items here.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                          ),
                          const SizedBox(height: 25),
                          AppSectionHeader(
                            title: 'Action needed',
                            actionLabel: '${urgent.length}',
                          ),
                          const SizedBox(height: 10),
                          if (urgent.isEmpty)
                            const EmptyState(
                              icon: Icons.notifications_none_rounded,
                              title: 'You are all caught up',
                              message:
                                  'There are no expired or soon-to-expire warranties.',
                            )
                          else
                            ...urgent.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _AlertCard(
                                  item: item,
                                  onTap: () => _openDetails(context, item),
                                ),
                              ),
                            ),
                          if (upcoming.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const AppSectionHeader(title: 'Later'),
                            const SizedBox(height: 10),
                            ...upcoming.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _AlertCard(
                                  item: item,
                                  onTap: () => _openDetails(context, item),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openDetails(BuildContext context, WarrantyItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WarrantyDetailsScreen(store: store, warrantyId: item.id),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.item, required this.onTap});

  final WarrantyItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = item.daysRemainingAt(now);
    final status = item.statusAt(now);
    final color = warrantyStatusColor(status);

    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
              border: Border.all(color: color.withValues(alpha: 0.45)),
            ),
            child: Icon(
              status == WarrantyStatus.expired
                  ? Icons.error_outline_rounded
                  : Icons.notifications_active_outlined,
              color: color,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  days < 0
                      ? 'Expired on ${formatDate(item.expiryDate)}'
                      : 'Expires ${formatDate(item.expiryDate)} • $days days left',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
