import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/date_formatters.dart';
import '../models/warranty_item.dart';
import '../state/warranty_store.dart';
import '../widgets/app_widgets.dart';
import 'alerts_screen.dart';
import 'warranty_details_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    required this.store,
    required this.onAddWarranty,
    required this.onSeeAll,
    super.key,
  });

  final WarrantyStore store;
  final VoidCallback onAddWarranty;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final expiring = store.warranties
        .where((item) => item.statusAt(now) == WarrantyStatus.expiringSoon)
        .take(3)
        .toList();
    final upcoming = expiring.isNotEmpty
        ? expiring
        : store.warranties
            .where((item) => item.statusAt(now) != WarrantyStatus.expired)
            .take(3)
            .toList();

    return AppPageBackground(
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _DashboardHeader(store: store),
                        const SizedBox(height: 27),
                        _OverviewCard(store: store, now: now),
                        const SizedBox(height: 20),
                        _ScanReceiptCard(onTap: onAddWarranty),
                        const SizedBox(height: 27),
                        AppSectionHeader(
                          title: expiring.isNotEmpty
                              ? 'Expiring soon'
                              : 'Your warranties',
                          actionLabel: 'See all',
                          onAction: onSeeAll,
                        ),
                        const SizedBox(height: 12),
                        if (upcoming.isEmpty)
                          EmptyState(
                            icon: Icons.shield_outlined,
                            title: 'No warranties yet',
                            message:
                                'Add your first purchase to start tracking its coverage.',
                            actionLabel: 'Add a warranty',
                            onAction: onAddWarranty,
                          )
                        else
                          ...upcoming.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: WarrantyCard(
                                item: item,
                                currency: store.currency,
                                onTap: () => _openDetails(context, item),
                                onFavorite: () => store.toggleFavorite(item.id),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.store});

  final WarrantyStore store;

  @override
  Widget build(BuildContext context) {
    final cleanName = store.userName.trim();
    final initials =
        cleanName.isEmpty ? 'U' : cleanName.substring(0, 1).toUpperCase();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${greetingFor(DateTime.now())}, ${store.userName.split(' ').first}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.65,
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                'Keep every purchase protected',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton.filledTonal(
              tooltip: 'Expiry alerts',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AlertsScreen(store: store),
                ),
              ),
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            if (store.expiringCountAt(DateTime.now()) > 0)
              Positioned(
                top: -2,
                right: -1,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.warning,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primaryBlue, AppColors.purple],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.25),
                blurRadius: 14,
              ),
            ],
          ),
          child: Text(
            initials,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.store, required this.now});

  final WarrantyStore store;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 21),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Warranty overview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${formatMoney(store.protectedValue, store.currency)} protected value',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.primary.withValues(alpha: 0.09),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                  ),
                ),
                child: const Icon(Icons.show_chart_rounded, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 25),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _OverviewItem(
                    icon: Icons.shield_outlined,
                    value: store.activeCountAt(now),
                    label: 'Active',
                    color: AppColors.primary,
                  ),
                ),
                const _OverviewDivider(),
                Expanded(
                  child: _OverviewItem(
                    icon: Icons.access_time_rounded,
                    value: store.expiringCountAt(now),
                    label: 'Expiring',
                    color: AppColors.warning,
                  ),
                ),
                const _OverviewDivider(),
                Expanded(
                  child: _OverviewItem(
                    icon: Icons.cancel_outlined,
                    value: store.expiredCountAt(now),
                    label: 'Expired',
                    color: AppColors.danger,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  const _OverviewItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.07),
            border: Border.all(color: color.withValues(alpha: 0.65)),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.19), blurRadius: 16),
            ],
          ),
          child: Icon(icon, color: color, size: 25),
        ),
        const SizedBox(height: 10),
        Text(
          '$value',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
      ],
    );
  }
}

class _OverviewDivider extends StatelessWidget {
  const _OverviewDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 12),
      color: AppColors.border.withValues(alpha: 0.58),
    );
  }
}

class _ScanReceiptCard extends StatelessWidget {
  const _ScanReceiptCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 23,
          ),
          BoxShadow(
            color: AppColors.purple.withValues(alpha: 0.17),
            blurRadius: 28,
            offset: const Offset(8, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF063758), Color(0xFF12336B), Color(0xFF292B72)],
            ),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.72)),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 21),
              child: Row(
                children: [
                  Container(
                    width: 61,
                    height: 61,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      color: AppColors.background.withValues(alpha: 0.4),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.65)),
                    ),
                    child: const Icon(
                      Icons.document_scanner_outlined,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scan a receipt',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add a warranty in seconds',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: const Color(0xFFA6C5E7),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
