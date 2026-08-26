import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 420,
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                        width: double.infinity,
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
                                Text('Warranty overview',
                                  style:GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                  ),
                                ),
                                const Spacer(),
                                Container(

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.cyanAccent.withValues(
                                        alpha: 0.05,
                                      ),
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
                                  child: IconButton(
                                      onPressed: () {
                                      },
                                      icon: Icon(Icons.area_chart,
                                        color: Colors.cyan,
                                        size: 25,
                                      )
                                  ),
                                )

                              ],
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 52,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(99),
                                            border: Border.all(
                                              color: Colors.cyan.withValues(alpha: 0.20),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.shield_outlined,
                                            color: Colors.cyanAccent,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text('8',
                                          style: GoogleFonts.poppins(
                                          fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.cyan
                                         ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text('Active',
                                        style: GoogleFonts.poppins(
                                         fontSize: 13,
                                          color: Colors.white54
                                         ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const SizedBox(
                                      height: 130,
                                      child: VerticalDivider(
                                        width: 32,
                                        thickness: 1,
                                        color: Colors.white24,
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        Container(
                                          width: 52,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(99),
                                            border: Border.all(
                                              color: Colors.orange.withValues(alpha: 0.20),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.access_time_outlined,
                                            color: Colors.orange,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text('2',
                                          style: GoogleFonts.poppins(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text('Expiring soon',
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: Colors.white54
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const SizedBox(
                                      height: 130,
                                      child: VerticalDivider(
                                        width: 32,
                                        thickness: 1,
                                        color: Colors.white24,
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        Container(
                                          width: 52,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(99),
                                            border: Border.all(
                                              color: Colors.red.withValues(alpha: 0.20),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.cancel_outlined,
                                            color: Colors.red,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text('1',
                                          style: GoogleFonts.poppins(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text('Expired',
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: Colors.white54
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                  )
                ],
           ),
          ),
        ),
      ),
    );
  }
}
