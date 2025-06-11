import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/Product.dart';
import '../../services/FavoriteService.dart';
import 'productPage.dart'; // Import ProductPage untuk navigasi detail
import 'package:shared_preferences/shared_preferences.dart'; // <--- Import ini

class FavoriteProductsPage extends StatefulWidget {
  const FavoriteProductsPage({super.key});

  @override
  State<FavoriteProductsPage> createState() => _FavoriteProductsPageState();
}

class _FavoriteProductsPageState extends State<FavoriteProductsPage> {
  final FavoriteService _favoriteService = FavoriteService();
  List<Product> _favoriteProducts = [];
  bool _isLoading = true;
  int? _currentUserId; // <--- Tambahkan variabel ini

  @override
  void initState() {
    super.initState();
    _initializeFavorites(); // <--- Panggil fungsi inisialisasi baru
  }

  // Fungsi inisialisasi baru
  Future<void> _initializeFavorites() async {
    _currentUserId = await getUserId(); // Dapatkan userId saat inisialisasi
    if (_currentUserId == null) {
      // Handle case where user is not logged in
      print('User is not logged in. Cannot load favorites.');
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to view favorites.')),
        );
      }
      setState(() {
        _isLoading = false; // Tetapkan isLoading menjadi false agar UI tidak terjebak
      });
      return;
    }
    _loadFavorites(); // Lanjutkan memuat favorit jika userId ada
  }

  Future<void> _loadFavorites() async {
    if (_currentUserId == null) return; // Pastikan userId ada sebelum memuat

    setState(() {
      _isLoading = true;
    });
    // Panggil getFavorites dengan userId
    List<Product> favorites = await _favoriteService.getFavorites(_currentUserId!);
    setState(() {
      _favoriteProducts = favorites;
      _isLoading = false;
    });
  }

  Future<void> _removeFavorite(Product product) async {
    if (_currentUserId == null) return; // Pastikan userId ada sebelum menghapus

    // Panggil toggleFavorite dengan userId
    await _favoriteService.toggleFavorite(_currentUserId!, product);
    _loadFavorites(); // Muat ulang daftar setelah penghapusan
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} removed from favorites')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tambahkan kondisi untuk menangani jika _currentUserId null
    if (_isLoading || _currentUserId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: _currentUserId == null
              ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Please log in to view your favorite products.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              // Anda bisa menambahkan tombol login di sini
            ],
          )
              : const CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _favoriteProducts.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No favorite products yet.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Start adding products you love!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = _favoriteProducts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            child: InkWell(
              onTap: () {
                // Navigasi ke halaman detail produk
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductPage(id: product.id),
                  ),
                ).then((_) => _loadFavorites()); // Muat ulang saat kembali
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(product.photoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.category,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            NumberFormat.currency(locale: 'id', symbol: 'Rp')
                                .format(product.price),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.blueAccent),
                      onPressed: () => _removeFavorite(product),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}