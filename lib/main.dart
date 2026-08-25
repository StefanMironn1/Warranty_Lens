import 'package:flutter/material.dart';
import 'app_screens/landing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WarrantyLens',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple)
      ),
      home: LandingScreen(),
    );
  }
}
