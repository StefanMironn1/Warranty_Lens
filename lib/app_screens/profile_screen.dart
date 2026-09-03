import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_theme.dart';
import '../core/date_formatters.dart';
import '../state/warranty_store.dart';
import '../widgets/app_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({required this.store, super.key});

  final WarrantyStore store;

  @override
  Widget build(BuildContext context) {
    final initials = _initials(store.userName);
    return AppPageBackground(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 112),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Profile & settings',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.7,
                          ),
                    ),
                    const SizedBox(height: 22),
                    GlassCard(
                      child: Row(
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primaryBlue,
                                  AppColors.purple,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryBlue
                                      .withValues(alpha: 0.25),
                                  blurRadius: 18,
                                ),
                              ],
                            ),
                            child: Text(
                              initials,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  store.userName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  store.email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  '${store.warranties.length} warranties • ${formatMoney(store.protectedValue, store.currency)} protected',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Edit profile',
                            onPressed: () => _editProfile(context),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 27),
                    const AppSectionHeader(title: 'Preferences'),
                    const SizedBox(height: 12),
                    GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          SwitchListTile.adaptive(
                            value: store.notificationsEnabled,
                            onChanged: (value) => store.updateSettings(
                              enableNotifications: value,
                            ),
                            secondary: const Icon(
                              Icons.notifications_active_outlined,
                              color: AppColors.primary,
                            ),
                            title: const Text('Expiry notifications'),
                            subtitle: Text(
                              store.notificationsEnabled
                                  ? 'Alerts are enabled'
                                  : 'Alerts are paused',
                            ),
                          ),
                          const Divider(height: 1),
                          _SettingsTile(
                            icon: Icons.currency_exchange_rounded,
                            title: 'Currency',
                            subtitle: _currencyName(store.currency),
                            trailing: store.currency,
                            onTap: () => _selectCurrency(context),
                          ),
                          const Divider(height: 1),
                          const _SettingsTile(
                            icon: Icons.cloud_off_outlined,
                            title: 'Local-first storage',
                            subtitle: 'Your data stays on this device',
                            trailing: 'Private',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 27),
                    const AppSectionHeader(title: 'Your data'),
                    const SizedBox(height: 12),
                    GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _SettingsTile(
                            icon: Icons.data_object_rounded,
                            title: 'Export data',
                            subtitle: 'Copy a portable JSON backup',
                            onTap: () => _exportData(context),
                          ),
                          const Divider(height: 1),
                          _SettingsTile(
                            icon: Icons.restore_rounded,
                            title: 'Restore demo data',
                            subtitle: 'Reset the portfolio sample warranties',
                            onTap: () => _restoreDemo(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 27),
                    const AppSectionHeader(title: 'About'),
                    const SizedBox(height: 12),
                    GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _SettingsTile(
                            icon: Icons.info_outline_rounded,
                            title: 'About WarrantyLens',
                            subtitle: 'Version 1.0.0 portfolio edition',
                            onTap: () => _showAbout(context),
                          ),
                          const Divider(height: 1),
                          _SettingsTile(
                            icon: Icons.logout_rounded,
                            iconColor: AppColors.danger,
                            title: 'Leave demo',
                            subtitle: 'Return to the welcome screen',
                            onTap: () => Navigator.of(context)
                                .pushNamedAndRemoveUntil(
                              '/welcome',
                              (route) => false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Made with Flutter • Designed for a clean, local-first experience',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
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

  Future<void> _editProfile(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: store.userName);
    final emailController = TextEditingController(text: store.email);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit profile'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter your name'
                    : null,
              ),
              const SizedBox(height: 13),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => (value ?? '').contains('@')
                    ? null
                    : 'Enter a valid email',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              await store.updateProfile(
                name: nameController.text,
                emailAddress: emailController.text,
              );
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    nameController.dispose();
    emailController.dispose();
  }

  Future<void> _selectCurrency(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Display currency',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              for (final currency in const ['EUR', 'USD', 'GBP'])
                ListTile(
                  onTap: () => Navigator.of(context).pop(currency),
                  title: Text(_currencyName(currency)),
                  leading: Text(
                    currency,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                  trailing: store.currency == currency
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                        )
                      : const Icon(Icons.circle_outlined),
                ),
            ],
          ),
        ),
      ),
    );
    if (selected != null) {
      await store.updateSettings(selectedCurrency: selected);
    }
  }

  Future<void> _exportData(BuildContext context) async {
    final data = store.exportJson();
    final messenger = ScaffoldMessenger.of(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Export data'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This JSON backup contains your profile and all warranty records.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 13),
              Container(
                constraints: const BoxConstraints(maxHeight: 260),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.background,
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    data,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Color(0xFFB8CCE2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: data));
              if (!dialogContext.mounted) return;
              Navigator.of(dialogContext).pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('JSON backup copied.')),
              );
            },
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Copy JSON'),
          ),
        ],
      ),
    );
  }

  Future<void> _restoreDemo(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Restore demo data?'),
        content: const Text(
          'Your current warranty list will be replaced by the original portfolio sample.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await store.restoreDemoData();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demo data restored.')),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'WarrantyLens',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryBlue],
          ),
        ),
        child: const Icon(
          Icons.verified_user_rounded,
          color: Color(0xFF001522),
          size: 32,
        ),
      ),
      children: const [
        Text(
          'A local-first Flutter portfolio application for organizing receipts, tracking warranty coverage and preparing claims.',
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  String _currencyName(String currency) => switch (currency) {
        'USD' => 'US Dollar',
        'GBP' => 'British Pound',
        _ => 'Euro',
      };
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor = AppColors.primary,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailing;
  final VoidCallback? onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColors.textSecondary),
      ),
      trailing: trailing == null
          ? onTap == null
              ? null
              : const Icon(Icons.chevron_right_rounded)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  trailing!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                if (onTap != null) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ],
            ),
    );
  }
}
