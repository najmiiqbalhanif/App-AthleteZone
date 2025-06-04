import 'package:flutter/material.dart';
import 'presentation/pages/login.dart'; // arahkan ke LoginPage, bukan MainLayout

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // opsional: untuk menghilangkan banner DEBUG
      home: const LoginPage(), // ✅ Ganti MainLayout dengan LoginPage
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
