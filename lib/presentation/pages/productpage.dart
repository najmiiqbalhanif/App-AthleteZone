import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce Detail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Gunakan Material 3 agar textTheme-nya sesuai versi Flutter baru
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const ProductDetailPage(),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Untuk PageView gambar
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Gambar contoh (ganti dengan gambar Anda sendiri)
  final List<String> _productImages = [
    'assets/images/shoes1.png',
    'assets/images/shoes2.png',
    'assets/images/shoes3.png',
  ];

  // Bottom navigation
  int _selectedBottomNavIndex = 0;

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });
    // Aksi lain sesuai kebutuhan (navigasi halaman dsb.)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar bisa disesuaikan, misal pakai IconButton untuk back, share, dsb.
      appBar: AppBar(
        title: const Text("Nike Air Force 1 '07"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        // Bisa tambahkan action icon (share, dsb.) di sini jika perlu
        actions: [
          IconButton(
            onPressed: () {
              // Aksi share dsb.
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Carousel Gambar Produk
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _productImages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                    _productImages[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            // Dots indicator
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _productImages.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 12 : 8,
                    height: _currentPage == index ? 12 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.black : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Nama Produk
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Nike Air Force 1 '07",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Kategori/Deskripsi Singkat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Men's Shoes",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Harga
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Rp 1.549.000",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Pilihan Warna / Variasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Warna Putih
                  _ColorOption(
                    color: Colors.white,
                    isSelected: _currentPage == 0,
                    onTap: () {
                      setState(() {
                        _pageController.jumpToPage(0);
                      });
                    },
                  ),
                  const SizedBox(width: 8),

                  // Warna Hitam
                  _ColorOption(
                    color: Colors.black,
                    isSelected: _currentPage == 1,
                    onTap: () {
                      setState(() {
                        _pageController.jumpToPage(1);
                      });
                    },
                  ),
                  const SizedBox(width: 8),

                  // Custom
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _pageController.jumpToPage(2);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                        color: _currentPage == 2
                            ? Colors.grey.shade200
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.color_lens, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            "Design Your Own",
                            style: TextStyle(
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Contoh row untuk 3 tombol: Select Size, Add to Bag, Favorite
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Aksi pilih size
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Select Size"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Aksi tambahkan ke keranjang
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Add to Bag"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Aksi favorite
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Favorite"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Informasi tambahan (sesuai screenshot)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "This product is excluded from all promotions and discounts.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Deskripsi panjang
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Comfortable, durable and timeless—it's number one for a reason. "
                    "The classic '80s construction pairs smooth leather with bold "
                    "details for style that tracks whether you're on the court or on the go.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Informasi detail
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "• Shown: White/White\n"
                    "• Style: CW2288-111\n"
                    "• Country/Region of Origin: India, Vietnam",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 16),

            // Tombol "View Product Details" (contoh)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () {
                  // Aksi menuju detail lebih lengkap
                },
                child: Text(
                  "View Product Details",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: _onBottomNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Bag',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Widget kecil untuk pilihan warna
class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
