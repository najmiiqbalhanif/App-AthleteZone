import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Shop',
            style: TextStyle(
            fontWeight: FontWeight.bold
            ),
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Shoes'),
              Tab(text: 'Jerseys'),
              Tab(text: 'Pants'),
              Tab(text: 'Socks'),
              Tab(text: 'Caps'),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
          ),
        ),
        body: TabBarView(
          children: [
            _buildProductGrid(category: 'Shoes'),
            _buildProductGrid(category: 'Jerseys'),
            _buildProductGrid(category: 'Pants'),
            _buildProductGrid(category: 'Socks'),
            _buildProductGrid(category: 'Caps'),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid({required String category}) {
    // Data dummy - sesuaikan dengan data asli Anda
    final List<Product> products = [
      Product(
        name: 'Nike Air Max',
        brand: 'Nike',
        category: 'Shoes',
        price: 1500000,
        image: 'assets/images/shoes1.png',
        tag: 'New',
      ),
      Product(
        name: 'Adidas Jersey',
        brand: 'Nike',
        category: 'Jerseys',
        price: 599000,
        image: 'assets/images/jersey1.jpg',
        tag: 'Popular',
      ),
      // Tambahkan data lainnya sesuai kategori
    ];

    // Filter produk berdasarkan kategori
    final filteredProducts = products.where((p) => p.category == category).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ProductItem(product: product);
      },
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  product.image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (product.tag != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.tag!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.brand,
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp${product.price.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (match) => '${match[1]}.'
                  )}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
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

class Product {
  final String name;
  final String category;
  final String brand;
  final int price;
  final String image;
  final String? tag;

  Product({
    required this.name,
    required this.category,
    required this.brand,
    required this.price,
    required this.image,
    this.tag,
  });
}