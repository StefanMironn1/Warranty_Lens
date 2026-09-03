import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/date_formatters.dart';
import '../models/warranty_item.dart';

class AppPageBackground extends StatelessWidget {
  const AppPageBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            Color(0xFF041426),
            Color(0xFF061B30),
          ],
        ),
      ),
      child: child,
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.borderRadius = 22,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surfaceLight.withValues(alpha: 0.82),
          AppColors.surface.withValues(alpha: 0.92),
        ],
      ),
      border: Border.all(color: AppColors.border.withValues(alpha: 0.72)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 18,
          offset: const Offset(0, 9),
        ),
      ],
    );

    if (onTap == null) {
      return Container(padding: padding, decoration: decoration, child: child);
    }

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: decoration,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.35,
                ),
          ),
        ),
        if (actionLabel != null)
          TextButton.icon(
            onPressed: onAction,
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 13),
            label: Text(actionLabel!),
          ),
      ],
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({required this.status, this.compact = false, super.key});

  final WarrantyStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = warrantyStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9 : 11,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.withValues(alpha: 0.09),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        warrantyStatusLabel(status),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: compact ? 9.5 : 10.5,
            ),
      ),
    );
  }
}

class WarrantyCard extends StatelessWidget {
  const WarrantyCard({
    required this.item,
    required this.currency,
    required this.onTap,
    this.onFavorite,
    super.key,
  });

  final WarrantyItem item;
  final String currency;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final status = item.statusAt(now);
    final color = warrantyStatusColor(status);
    final days = item.daysRemainingAt(now);

    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          ProductVisual(item: item, size: 72),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.22,
                            ),
                      ),
                    ),
                    if (onFavorite != null)
                      InkResponse(
                        onTap: onFavorite,
                        radius: 22,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 2, 6),
                          child: Icon(
                            item.isFavorite
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: item.isFavorite
                                ? AppColors.warning
                                : AppColors.textSecondary,
                            size: 22,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.brand.isEmpty ? item.category : item.brand}  •  ${formatMoney(item.price, currency)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    StatusPill(status: status, compact: true),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        days < 0
                            ? 'Expired ${-days} days ago'
                            : days == 0
                                ? 'Expires today'
                                : '$days days left',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: item.progressAt(now),
                    minHeight: 6,
                    backgroundColor: AppColors.border.withValues(alpha: 0.45),
                    valueColor: AlwaysStoppedAnimation(color),
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

class ProductVisual extends StatelessWidget {
  const ProductVisual({required this.item, this.size = 72, super.key});

  final WarrantyItem item;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(item.imageAsset == null ? size * 0.22 : size * 0.1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.25),
        color: const Color(0xFF0A1B2F),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
      ),
      child: item.imageAsset == null
          ? Icon(
              categoryIcon(item.category),
              color: AppColors.primary,
              size: size * 0.48,
            )
          : Image.asset(
              item.imageAsset!,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                categoryIcon(item.category),
                color: AppColors.primary,
                size: size * 0.48,
              ),
            ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 54),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.09),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.45),
              ),
            ),
            child: Icon(icon, color: AppColors.primary, size: 38),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 22),
            ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

Color warrantyStatusColor(WarrantyStatus status) => switch (status) {
      WarrantyStatus.active => AppColors.success,
      WarrantyStatus.expiringSoon => AppColors.warning,
      WarrantyStatus.expired => AppColors.danger,
    };

String warrantyStatusLabel(WarrantyStatus status) => switch (status) {
      WarrantyStatus.active => 'Active',
      WarrantyStatus.expiringSoon => 'Expiring soon',
      WarrantyStatus.expired => 'Expired',
    };

IconData categoryIcon(String category) => switch (category.toLowerCase()) {
      'phone' => Icons.smartphone_rounded,
      'computer' => Icons.laptop_mac_rounded,
      'audio' => Icons.headphones_rounded,
      'camera' => Icons.photo_camera_outlined,
      'home appliance' => Icons.kitchen_outlined,
      'gaming' => Icons.sports_esports_outlined,
      'vehicle' => Icons.directions_car_outlined,
      _ => Icons.inventory_2_outlined,
    };
