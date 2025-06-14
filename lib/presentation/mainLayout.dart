// lib/mainLayout.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:helloworld/presentation/pages/cart_provider.dart'; // Import CartProvider

import 'pages/homepage.dart';
import 'pages/shoppage.dart'; // Ini akan menjadi tab yang memuat Navigator bersarang
import 'pages/ordersPage.dart';
import 'pages/cartpage.dart';
import 'pages/profilepage.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;

  const MainLayout({super.key, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    const HomePage(),
    const ShopPage(),
    const OrdersPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant MainLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      setState(() {
        _selectedIndex = widget.initialIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SizedBox(
          height: 45,
          child: Image.asset(
            'assets/images/athletezone-logo-mini.png', // Pastikan path ini benar
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (_selectedIndex != index) {
            // Logika untuk mereset Navigator internal jika diperlukan (lebih lanjut)
          }
          setState(() => _selectedIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[900], // Warna ikon/label yang dipilih
        unselectedItemColor: Colors.grey, // Warna ikon/label yang tidak dipilih
        showUnselectedLabels: true, // Tampilkan label untuk yang tidak dipilih
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          // --- Bagian yang dimodifikasi untuk ikon Cart ---
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final int totalItems = cartProvider.totalItems;
                final String displayCount = totalItems > 9 ? '9+' : '$totalItems';

                return Stack(
                  clipBehavior: Clip.none, // Penting untuk badge agar tidak terpotong
                  children: [
                    const Icon(Icons.shopping_cart_outlined), // Ikon keranjang default
                    if (totalItems > 0) // Tampilkan badge hanya jika ada item
                      Positioned(
                        right: -5, // Sesuaikan posisi horizontal
                        top: -5,  // Sesuaikan posisi vertikal
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.blue[900], // Warna latar belakang badge
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 1), // Border putih
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18, // Ukuran minimum badge
                            minHeight: 18,
                          ),
                          child: Text(
                            displayCount,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            activeIcon: Consumer<CartProvider>( // Untuk ikon aktif juga
              builder: (context, cartProvider, child) {
                final int totalItems = cartProvider.totalItems;
                final String displayCount = totalItems > 9 ? '9+' : '$totalItems';
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart), // Ikon keranjang aktif
                    if (totalItems > 0)
                      Positioned(
                        right: -5,
                        top: -5,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            displayCount,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: 'Cart',
          ),
          // --- Akhir bagian yang dimodifikasi ---
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}