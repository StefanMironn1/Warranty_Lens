import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../state/warranty_store.dart';
import 'sign_in_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({required this.store, super.key});

  final WarrantyStore store;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const WarrantyBackground(),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.08),
                  const Color(0xFF001124).withValues(alpha: 0.35),
                  const Color(0xFF001124).withValues(alpha: 0.92),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isTablet ? 48 : 24,
                  isTablet ? 44 : 28,
                  isTablet ? 48 : 24,
                  28,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryBlue],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 25,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.verified_user_rounded,
                          color: Color(0xFF001526),
                          size: 37,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'WarrantyLens',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontSize: isTablet ? 48 : 39,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.7,
                            ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        'Every purchase protected. Every receipt in reach.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.74),
                              height: 1.5,
                            ),
                      ),
                      SizedBox(height: isTablet ? 42 : 30),
                      const _FeaturePanel(),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SignInScreen(store: store),
                            ),
                          ),
                          child: const Text('Get started'),
                        ),
                      ),
                      const SizedBox(height: 13),
                      Text(
                        'Local-first demo • No account required',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.58),
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
    );
  }
}

class _FeaturePanel extends StatelessWidget {
  const _FeaturePanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Colors.white.withValues(alpha: 0.09),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: AppColors.primary.withValues(alpha: 0.14),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.primary,
                  size: 29,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Protect your purchases',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Know exactly what is covered and for how long.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.62),
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(
                child: _SmallFeature(
                  icon: Icons.document_scanner_outlined,
                  text: 'Receipt scan',
                ),
              ),
              SizedBox(width: 11),
              Expanded(
                child: _SmallFeature(
                  icon: Icons.notifications_none_rounded,
                  text: 'Expiry alerts',
                ),
              ),
              SizedBox(width: 11),
              Expanded(
                child: _SmallFeature(
                  icon: Icons.insights_outlined,
                  text: 'Insights',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallFeature extends StatelessWidget {
  const _SmallFeature({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.07),
      ),
      child: Column(
        children: [
          Icon(icon, size: 19, color: AppColors.primary),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class WarrantyBackground extends StatelessWidget {
  const WarrantyBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.shortestSide >= 600;
    final isLandscape = size.width > size.height;

    final background = !isTablet
        ? 'assets/images/backround_images/warranty_phone.png'
        : isLandscape
            ? 'assets/images/backround_images/warranty_tablet_landscape.png'
            : 'assets/images/backround_images/warranty_tablet_portrait.png';

    return Image.asset(
      background,
      fit: BoxFit.cover,
      alignment: Alignment.bottomCenter,
      filterQuality: FilterQuality.high,
    );
  }
}
