import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/date_formatters.dart';
import '../models/warranty_item.dart';
import '../state/warranty_store.dart';
import '../widgets/app_widgets.dart';
import 'warranty_form_screen.dart';

class WarrantyDetailsScreen extends StatelessWidget {
  const WarrantyDetailsScreen({
    required this.store,
    required this.warrantyId,
    super.key,
  });

  final WarrantyStore store;
  final String warrantyId;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final item = store.findById(warrantyId);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Warranty details'),
            actions: [
              if (item != null)
                IconButton(
                  tooltip: item.isFavorite
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                  onPressed: () => store.toggleFavorite(item.id),
                  icon: Icon(
                    item.isFavorite
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: item.isFavorite
                        ? AppColors.warning
                        : AppColors.textPrimary,
                  ),
                ),
              PopupMenuButton<String>(
                enabled: item != null,
                onSelected: (value) {
                  if (item == null) return;
                  if (value == 'edit') _edit(context, item);
                  if (value == 'delete') _delete(context, item);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit warranty'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline_rounded),
                      title: Text('Delete'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 7),
            ],
          ),
          body: AppPageBackground(
            child: item == null
                ? const EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'Warranty not found',
                    message: 'This item may have already been deleted.',
                  )
                : _DetailsBody(store: store, item: item),
          ),
        );
      },
    );
  }

  Future<void> _edit(BuildContext context, WarrantyItem item) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WarrantyFormScreen(store: store, initialItem: item),
      ),
    );
  }

  Future<void> _delete(BuildContext context, WarrantyItem item) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete warranty?'),
        content: Text(
          '${item.productName} and its saved receipt will be removed from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !context.mounted) return;
    await store.deleteWarranty(item.id);
    if (context.mounted) Navigator.of(context).pop();
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.store, required this.item});

  final WarrantyStore store;
  final WarrantyItem item;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final status = item.statusAt(now);
    final color = warrantyStatusColor(status);
    final days = item.daysRemainingAt(now);

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0B3A59), Color(0xFF182B63)],
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.45),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.13),
                          blurRadius: 28,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ProductVisual(item: item, size: 118),
                        const SizedBox(height: 19),
                        Text(
                          item.productName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.6,
                              ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          [item.brand, item.category]
                              .where((text) => text.isNotEmpty)
                              .join('  •  '),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFFAFC8E5),
                              ),
                        ),
                        const SizedBox(height: 15),
                        StatusPill(status: status),
                        const SizedBox(height: 18),
                        Text(
                          days < 0
                              ? 'Expired ${-days} days ago'
                              : days == 0
                                  ? 'Coverage expires today'
                                  : '$days days of coverage remaining',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: item.progressAt(now),
                            minHeight: 8,
                            backgroundColor:
                                AppColors.background.withValues(alpha: 0.5),
                            valueColor: AlwaysStoppedAnimation(color),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const AppSectionHeader(title: 'Coverage information'),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 560;
                      final cards = [
                        _InfoCard(
                          icon: Icons.calendar_today_outlined,
                          label: 'Purchased',
                          value: formatDate(item.purchaseDate),
                        ),
                        _InfoCard(
                          icon: Icons.event_available_outlined,
                          label: 'Expires',
                          value: formatDate(item.expiryDate),
                          valueColor: color,
                        ),
                        _InfoCard(
                          icon: Icons.payments_outlined,
                          label: 'Purchase value',
                          value: formatMoney(item.price, store.currency),
                        ),
                        _InfoCard(
                          icon: Icons.timer_outlined,
                          label: 'Coverage length',
                          value: _durationLabel(item.warrantyMonths),
                        ),
                      ];

                      if (!isWide) {
                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 11,
                          crossAxisSpacing: 11,
                          childAspectRatio: 1.35,
                          children: cards,
                        );
                      }
                      return SizedBox(
                        height: 128,
                        child: Row(
                          children: cards
                              .map(
                                (card) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: card,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  const AppSectionHeader(title: 'Purchase details'),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.storefront_outlined,
                          label: 'Retailer',
                          value: item.retailer.isEmpty ? 'Not added' : item.retailer,
                        ),
                        const Divider(height: 1),
                        _DetailRow(
                          icon: Icons.qr_code_2_rounded,
                          label: 'Serial number',
                          value: item.serialNumber.isEmpty
                              ? 'Not added'
                              : item.serialNumber,
                        ),
                        const Divider(height: 1),
                        _DetailRow(
                          icon: Icons.notifications_active_outlined,
                          label: 'Expiry reminder',
                          value: '${item.reminderDays} days before',
                        ),
                      ],
                    ),
                  ),
                  if (item.receiptFileName.isNotEmpty) ...[
                    const SizedBox(height: 25),
                    const AppSectionHeader(title: 'Receipt'),
                    const SizedBox(height: 12),
                    GlassCard(
                      onTap: () => _showReceipt(context),
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.primary.withValues(alpha: 0.1),
                            ),
                            child: const Icon(
                              Icons.receipt_long_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.receiptFileName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Saved locally on this device',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.visibility_outlined),
                        ],
                      ),
                    ),
                  ],
                  if (item.notes.isNotEmpty) ...[
                    const SizedBox(height: 25),
                    const AppSectionHeader(title: 'Notes'),
                    const SizedBox(height: 12),
                    GlassCard(
                      child: Text(
                        item.notes,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFFC1D1E4),
                              height: 1.6,
                            ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: () => _showClaimGuide(context),
                    icon: const Icon(Icons.support_agent_rounded),
                    label: const Text('Start a warranty claim'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => WarrantyFormScreen(
                          store: store,
                          initialItem: item,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit warranty'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReceipt(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.receipt_long_rounded,
                color: AppColors.primary,
                size: 58,
              ),
              const SizedBox(height: 14),
              Text(
                item.receiptFileName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Receipt preview is represented by metadata in this self-contained demo. A production build can connect this view to encrypted cloud storage.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClaimGuide(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Claim checklist',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 7),
              Text(
                'Prepare these details before contacting ${item.retailer}.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              const _ChecklistItem(
                number: '1',
                title: 'Describe the issue',
                subtitle: 'Note when it started and how to reproduce it.',
              ),
              const _ChecklistItem(
                number: '2',
                title: 'Have proof of purchase ready',
                subtitle: 'Your receipt information is already saved here.',
              ),
              const _ChecklistItem(
                number: '3',
                title: 'Keep the serial number nearby',
                subtitle: 'The retailer may use it to confirm coverage.',
              ),
              const SizedBox(height: 13),
              ElevatedButton.icon(
                onPressed: () {
                  final messenger = ScaffoldMessenger.of(context);
                  Navigator.of(context).pop();
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Claim checklist marked as prepared.'),
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('I am ready to contact the retailer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _durationLabel(int months) {
    if (months < 12) return '$months months';
    final years = months ~/ 12;
    return '$years ${years == 1 ? 'year' : 'years'}';
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 21),
          const Spacer(),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 23),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  final String number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.primary.withValues(alpha: 0.14),
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
