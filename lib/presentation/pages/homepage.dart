import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'productpage.dart';
import '../../services/homepageservice.dart';
import '../../models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _products = [];
  bool _isLoading = true;
  String _userName = 'Pengguna'; // Nilai default jika nama belum tersedia

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Panggil fungsi untuk memuat nama pengguna
    fetchProducts();
  }

  // Fungsi baru untuk memuat nama pengguna dari SharedPreferences
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName'); // Ambil nilai dari kunci 'userName'
    if (userName != null && userName.isNotEmpty) {
      setState(() {
        _userName = userName;
      });
    }
  }

  void fetchProducts() async {
    try {
      final products = await Homepageservice.fetchHomepageProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Selamat Datang, $_userName", // Gunakan nama pengguna yang dimuat di sini
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pilihan Terbaik untuk Anda",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Produk rekomendasi",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 150,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _products.map((product) {
                      return ProductCard(
                        imageUrl: product.photoUrl,
                        title: product.name,
                        category: product.category,
                        price: 'Rp ${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.',)}',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(id: product.id),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const PromoCarousel(),
              const SizedBox(height: 24),
              const BigPromoBanner(),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        // Aksi saat tombol ditekan
                      },
                      child: const Text(
                        'Lihat Selengkapnya',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Image.asset(
                      'assets/images/athletezone-logo-mini.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Terima kasih telah bergabung bersama kami.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final String price;
  final VoidCallback onTap; // Tambahkan ini

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.price,
    required this.onTap, // Tambahkan ini
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Tambahkan ini
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:Image.network(
                imageUrl,
                width: 150,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 150);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              category,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _promos = [
    {
      "image": "assets/images/shoes1.png",
      "title": "New Week, New Looks 📣",
      "subtitle": "Give your wardrobe a boost with this week's fresh arrivals."
    },
    {
      "image": "assets/images/shoes2.png",
      "title": "Stay Active, Stay Fresh 🏃",
      "subtitle": "Find the perfect pair for your daily workout routine."
    },
    {
      "image": "assets/images/shoes3.png",
      "title": "Step into Style 👟",
      "subtitle": "Explore new designs that match your vibe."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: PageView.builder(
            controller: _controller,
            itemCount: _promos.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final promo = _promos[index];
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(promo["image"]!, width: 60, height: 60),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            promo["title"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            promo["subtitle"]!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promos.length, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.black : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class BigPromoBanner extends StatelessWidget {
  const BigPromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Image.asset(
            "assets/images/iklan.jpg", // Gambar iklan kamu
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 24,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Navigasi ke halaman produk, atau aksi lainnya
                  },
                  child: const Text(
                    "Shop",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}