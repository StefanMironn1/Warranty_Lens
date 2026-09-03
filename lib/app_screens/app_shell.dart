import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../state/warranty_store.dart';
import 'dashboard_screen.dart';
import 'insights_screen.dart';
import 'profile_screen.dart';
import 'warranty_form_screen.dart';
import 'warranties_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({required this.store, super.key});

  final WarrantyStore store;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  Future<void> _openAddWarranty() async {
    final wasAdded = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => WarrantyFormScreen(store: widget.store),
      ),
    );
    if (wasAdded == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Warranty saved to your vault.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final pages = [
          DashboardScreen(
            store: widget.store,
            onAddWarranty: _openAddWarranty,
            onSeeAll: () => setState(() => _selectedIndex = 1),
          ),
          WarrantiesScreen(
            store: widget.store,
            onAddWarranty: _openAddWarranty,
          ),
          InsightsScreen(store: widget.store),
          ProfileScreen(store: widget.store),
        ];

        return Scaffold(
          extendBody: true,
          body: IndexedStack(index: _selectedIndex, children: pages),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.32),
                  blurRadius: 22,
                ),
              ],
            ),
            child: FloatingActionButton(
              heroTag: 'add-warranty',
              tooltip: 'Add warranty',
              onPressed: _openAddWarranty,
              backgroundColor: AppColors.primary,
              foregroundColor: const Color(0xFF001522),
              shape: const CircleBorder(),
              child: const Icon(Icons.add_rounded, size: 32),
            ),
          ),
          bottomNavigationBar: _AppNavigationBar(
            selectedIndex: _selectedIndex,
            onSelected: (index) => setState(() => _selectedIndex = index),
          ),
        );
      },
    );
  }
}

class _AppNavigationBar extends StatelessWidget {
  const _AppNavigationBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A223A), Color(0xFF041225)],
        ),
        border: Border(
          top: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              _NavigationItem(
                label: 'Home',
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                isSelected: selectedIndex == 0,
                onTap: () => onSelected(0),
              ),
              _NavigationItem(
                label: 'Warranties',
                icon: Icons.shield_outlined,
                selectedIcon: Icons.shield_rounded,
                isSelected: selectedIndex == 1,
                onTap: () => onSelected(1),
              ),
              const SizedBox(width: 70),
              _NavigationItem(
                label: 'Insights',
                icon: Icons.insights_outlined,
                selectedIcon: Icons.insights_rounded,
                isSelected: selectedIndex == 2,
                onTap: () => onSelected(2),
              ),
              _NavigationItem(
                label: 'Profile',
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                isSelected: selectedIndex == 3,
                onTap: () => onSelected(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.textSecondary;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 3,
              width: isSelected ? 26 : 0,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.55),
                    blurRadius: 7,
                  ),
                ],
              ),
            ),
            Icon(isSelected ? selectedIcon : icon, color: color, size: 25),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 10.5,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
