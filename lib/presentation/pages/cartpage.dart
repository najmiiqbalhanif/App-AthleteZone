import 'package:flutter/material.dart';
import '../../services/CartService.dart';
import '../../models/CartItem.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  late Future<int?> _futureUserId;

  @override
  void initState() {
    super.initState();
    _futureUserId = getUserId();
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: _futureUserId,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!userSnapshot.hasData || userSnapshot.data == null) {
          return const Center(child: Text("User not found"));
        }

        final userId = userSnapshot.data!;

        return FutureBuilder<List<CartItem>>(
          future: _cartService.getCartItems(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Your cart is empty."));
            } else {
              List<CartItem> cartItems = snapshot.data!;
              double totalPrice = _cartService.getTotalPrice();

              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Cart',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          return _buildCartItem(context, cartItems[index]);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey.shade300)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          _buildTotalRow('Subtotal', 'Rp ${totalPrice.toStringAsFixed(0).replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (match) => '${match[1]}.',)}'),
                          _buildTotalRow('Shipping', 'Standard - Free'),
                          _buildTotalRow('Estimated Total', 'Rp ${totalPrice.toStringAsFixed(0).replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (match) => '${match[1]}.',)} + Tax', isBold: true),

                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF041761),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () {
                                // Implementasi navigasi ke halaman checkout
                              },
                              child: const Text(
                                'Checkout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }


  // Widget untuk membangun tampilan setiap item dalam keranjang
  Widget _buildCartItem(BuildContext context, CartItem cartItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Bagian Gambar dan Teks Tambahan ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container untuk gambar produk
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(cartItem.product.photoUrl),  // Menggunakan photoUrl dari Product
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Qty: ${cartItem.quantity}",  // Menampilkan jumlah
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,  // Nama produk
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cartItem.product.category,  // Kategori produk
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Price and Quantity Control
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Rp ${cartItem.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),(match) => '${match[1]}.',)}",  // Total harga untuk item ini

                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Widget untuk menampilkan baris total (Subtotal, Shipping, Estimated Total)
  Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xFF041761) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}