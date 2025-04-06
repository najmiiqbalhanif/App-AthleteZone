import 'package:flutter/material.dart';
import 'presentation/mainLayout.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainLayout(), // MainLayout sebagai root
      title: 'AthleteZone',
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF06207C), // Contoh warna kustom
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        )
      ),
    );
  }
}