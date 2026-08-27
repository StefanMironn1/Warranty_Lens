import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _DashboardNavigationBar(
        selectedIndex: _selectedIndex,
        onSelected: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      backgroundColor: const Color(0xFF060C2F),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: SingleChildScrollView(
          child: SafeArea(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Good Morning, Stefan',
                              style:GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                            const SizedBox(height: 7,),
                            Text('Keep your purchases protected',
                              style:GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF516988),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                        },
                            icon: Icon(Icons.notifications_none_outlined,
                            color: Colors.white,
                              size: 30,
                            )
                        ),
                        const SizedBox(width: 15),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: Color(0xFF243247)
                          ),
                          child: IconButton(
                              onPressed: () {
                              },
                              icon: Icon(Icons.person,
                                color: Colors.white,
                                size: 30,
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const _OverviewCard(),
                  const SizedBox(height: 20),
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
                            color: Colors.cyan.withValues(alpha: 0.20),
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
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.cyanAccent.withValues(
                                      alpha: 0.15,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.document_scanner_outlined,
                                    color: Colors.cyanAccent,
                                    size: 30,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Scan a receipt',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Add a warranty in seconds',
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
                                IconButton(onPressed: () {

                                }, icon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                 )
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Expiring soon',style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      ),
                      const Spacer(),
                      IconButton(onPressed: () {

                      }, icon: Row(
                       children: [
                         Text('See all',
                           style: GoogleFonts.poppins(
                           color: Color(0xFF2885CD),
                           fontSize: 13,
                          ),
                         ),
                         Icon(Icons.arrow_forward_ios,
                         size: 14,
                           color: Colors.cyan,
                         ),
                       ],
                      )
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
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
                            color: Colors.cyan.withValues(alpha: 0.20),
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
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.20),
                                    ),
                                  ),

                                  child: Image.asset('assets/images/warranty_devices_photos/airpods_photo-removebg-preview.png')
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'AirPods Pro',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '18 days left',
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
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.white.withValues(alpha: 0.10),
                                      border: Border.all(
                                        color: Colors.orange.withValues(alpha: 0.20),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.20),
                                          blurRadius: 25,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'Expiring soon',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                )                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
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
                            color: Colors.cyan.withValues(alpha: 0.20),
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
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.20),
                                      ),
                                    ),

                                    child: Image.asset('assets/images/warranty_devices_photos/washing-machine-isolated-removebg-preview.png')
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Washing Machine',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '42 days left',
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
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.white.withValues(alpha: 0.10),
                                      border: Border.all(
                                        color: Colors.cyanAccent.withValues(alpha: 0.20),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.20),
                                          blurRadius: 25,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'Active',
                                      style: TextStyle(
                                        color: Colors.cyanAccent,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
           ),
          ),
        ),
      ),
    );
  }
}



class _DashboardNavigationBar extends StatelessWidget{
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _DashboardNavigationBar({
    required this.onSelected,
    required this.selectedIndex
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF08213B),
            Color(0xFF04152A),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF2C6088).withValues(alpha: 0.45),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 76,
          child: Row(
            children: [
              Expanded(
                child: _NavigationItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  selected: selectedIndex == 0,
                  onTap: () => onSelected(0),
                ),
              ),
              Expanded(
                child: _NavigationItem(
                  icon: Icons.shield_outlined,
                  label: 'Warranties',
                  selected: selectedIndex == 1,
                  onTap: () => onSelected(1),
                ),
              ),
              Expanded(
                child: _NavigationItem(
                  icon: Icons.document_scanner_outlined,
                  label: 'Scan',
                  selected: selectedIndex == 2,
                  isPrimary: true,
                  onTap: () => onSelected(2),
                ),
              ),
              Expanded(
                child: _NavigationItem(
                  icon: Icons.wallet_outlined,
                  label: 'Feature',
                  selected: selectedIndex == 3,
                  onTap: () => onSelected(3),
                ),
              ),
              Expanded(
                child: _NavigationItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  selected: selectedIndex == 4,
                  onTap: () => onSelected(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget{

  final IconData icon;
  final String label;
  final bool selected;
  final bool isPrimary;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.selected,
    this.isPrimary = false,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isPrimary || selected
        ? const Color(0xFF19CFFF)
        : const Color(0xFF6F91BB);
    return InkWell(
      onTap: onTap,
      child: Transform.translate(
        offset: Offset(0, isPrimary ? -13 : 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isPrimary)
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF082B4E),
                  border: Border.all(
                    color: const Color(0xFF18DFFF),
                    width: 1.3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF18DFFF).withValues(alpha: 0.25),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: Icon(icon, color: const Color(0xFF8AF4FF), size: 29),
              )
            else ...[
              if (selected)
                Container(
                  width: 30,
                  height: 3,
                  margin: const EdgeInsets.only(bottom: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: activeColor,
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.65),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              Icon(icon, color: activeColor, size: 27),
            ],
            SizedBox(height: isPrimary ? 3 : 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: selected || isPrimary
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: isPrimary ? Colors.white : activeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _OverviewDivider extends StatelessWidget{
  const _OverviewDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      color: const Color(0xFF5E789C).withValues(alpha: 0.42),
    );
  }


}

class _GlassCard extends StatelessWidget{

  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassCard({required this.child,required this.padding});

  @override
  Widget build(BuildContext context) {
   return Container(
     padding: padding,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(24),
       gradient: const LinearGradient(
         begin: Alignment.topLeft,
         end: Alignment.bottomRight,
         colors: [
           Color(0xFF0A2A49),
           Color(0xFF071B33),
         ],
       ),
       border: Border.all(
         color: const Color(0xFF3E83B8).withValues(alpha: 0.68),
       ),
       boxShadow: [
         BoxShadow(
           color: Colors.black.withValues(alpha: 0.25),
           blurRadius: 18,
           offset: const Offset(0, 10),
         ),
       ],
     ),
     child: child,
   );
  }


}

class _OverviewCard extends StatelessWidget{
  const _OverviewCard();

  @override
  Widget build(BuildContext context) {

    return _GlassCard(
      padding:const EdgeInsets.fromLTRB(20, 18, 20, 22),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                    'Warranty overview',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                    ),
                  ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF0A2945),
                  border: Border.all(
                    color: const Color(0xFF2D81B8).withValues(alpha: 0.45),
                  ),
                ),
                child: const Icon(
                  Icons.show_chart_rounded,
                  color: Color(0xFF31DDF4),
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _OverviewItem(
                      icon: Icons.shield_outlined,
                      value: '8',
                      label: 'Active',
                      color: Color(0xFF12D9FF),
                  ),
                ),
                _OverviewDivider(),
                Expanded(
                  child: _OverviewItem(
                    icon: Icons.access_time_outlined,
                    value: '2',
                    label: 'Expiring soon',
                    color: Color(0xFFFFB52E),
                  ),
                ),
                _OverviewDivider(),
                Expanded(
                  child: _OverviewItem(
                    icon: Icons.cancel_outlined,
                    value: '1',
                    label: 'Expired',
                    color: Color(0xFFFF4961),
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

class _OverviewItem extends StatelessWidget{

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _OverviewItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.06),
            border: Border.all(
              color: color.withValues(alpha: 0.78),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.27),
                blurRadius: 17,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 33,
            height: 1,
            color: color,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                color: color.withValues(alpha: 0.42),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF7896BD),
            ),
          ),
        ),
      ],
    );
  }
}
