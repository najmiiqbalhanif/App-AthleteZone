import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import package provider
import 'presentation/pages/login.dart'; // Arahkan ke LoginPage
import 'services/notification_service.dart'; // Import NotificationService
import 'presentation/pages/cart_provider.dart'; // Sesuaikan path ini (CartProvider)

void main() async {
  // Pastikan binding Flutter sudah diinisialisasi sebelum memanggil native code
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi NotificationService
  await NotificationService.initialize();

  // Jalankan aplikasi dengan ChangeNotifierProvider sebagai root widget
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
      home: const LoginPage(), // Aplikasi dimulai dari LoginPage
      title: 'AthleteZone',
      theme: ThemeData(
        // Tema aplikasi umum
        primarySwatch: Colors.blue, // Contoh warna primer
        colorScheme: ColorScheme.light( // Contoh skema warna
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: Colors.blue,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData( // Contoh tema ElevatedButton
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[900],
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData( // Contoh tema OutlinedButton
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.blue[900]!),
            foregroundColor: Colors.blue[900],
          ),
        ),
        // Tema untuk BottomNavigationBar
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