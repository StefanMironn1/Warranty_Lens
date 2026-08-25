import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
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

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 48 : 24,
              ),
              child: Column(
                children: [
                  SizedBox(height: isTablet ? 80 : 45),

                  Text(
                    'WarrantyLens',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 52 : 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'All your warranties in one safe place',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 17 : 14,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Containerul principal
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 420,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white.withValues(alpha: 0.10),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.20),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.cyanAccent.withValues(
                                      alpha: 0.15,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.verified_user_outlined,
                                    color: Colors.cyanAccent,
                                    size: 28,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Protect your purchases',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Never lose a receipt or warranty again.',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.white.withValues(
                                            alpha: 0.65,
                                          ),
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
                                    text: 'Scan receipts',
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _SmallFeature(
                                    icon: Icons.notifications_none_rounded,
                                    text: 'Expiry alerts',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),
                ],
              ),
            ),
          ),
          Positioned(
            left:  isTablet ? 400: 24,
            right: isTablet ? 400  : 24,
            bottom: isTablet ? 70 : 70,
             child:  ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Aici vei deschide următorul ecran
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF06294B),
                      elevation: 8,
                      shadowColor: Colors.black.withValues(alpha: 0.30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'Get Started',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          )
        ],
      ),
    );
  }
}


class _SmallFeature extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SmallFeature({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.08),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.cyanAccent,
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white,
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

    final String background;

    if (!isTablet) {
      background =
      'assets/images/backround_images/warranty_phone.png';
    } else if (isLandscape) {
      background =
      'assets/images/backround_images/warranty_tablet_landscape.png';
    } else {
      background =
      'assets/images/backround_images/warranty_tablet_portrait.png';
    }

    return Positioned.fill(
      child: Image.asset(
        background,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}