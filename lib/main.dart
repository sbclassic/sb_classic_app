import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'utils/cart.dart'; // ✅ Import CartManager

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure platform binding
  await CartManager.loadCart(); // ✅ Load saved cart before app runs
  runApp(const SBClassicApp());
}

class SBClassicApp extends StatelessWidget {
  const SBClassicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SB Classic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
