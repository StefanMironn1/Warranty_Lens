import 'package:flutter/material.dart';

import 'app_screens/landing_screen.dart';
import 'core/app_theme.dart';
import 'state/warranty_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = WarrantyStore();
  await store.load();
  runApp(WarrantyLensApp(store: store));
}

class WarrantyLensApp extends StatelessWidget {
  const WarrantyLensApp({required this.store, super.key});

  final WarrantyStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WarrantyLens',
      theme: AppTheme.dark,
      home: LandingScreen(store: store),
      routes: {
        '/welcome': (_) => LandingScreen(store: store),
      },
    );
  }
}
