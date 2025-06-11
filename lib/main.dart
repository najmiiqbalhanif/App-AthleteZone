import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import package provider
import 'package:helloworld/presentation/pages/login.dart'; // Arahkan ke LoginPage
import 'package:helloworld/presentation/pages/cart_provider.dart'; // Sesuaikan path ini

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      title: 'AthleteZone',
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: const Color(0xFF06207C),
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}