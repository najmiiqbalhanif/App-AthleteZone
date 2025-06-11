import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helloworld/presentation/pages/cart_provider.dart'; // Pastikan path ini benar
import '../../services/cartService.dart'; // Untuk interaksi API backend
import '../../models/CartItem.dart'; // Model CartItem Anda
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helloworld/presentation/pages/checkoutPayment.dart'; // Pastikan path ini benar

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  Future<int?>? _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeCartData();
  }

  Future<int?> _initializeCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      return null;
    }

    try {
      final initialCartItems = await _cartService.getCartItems(userId);
      if (!mounted) {
        return userId;
      }

      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.clearCart();

      if (initialCartItems.isNotEmpty) {
        for (var item in initialCartItems) {
          cartProvider.addExistingItem(item.product, item.quantity);
        }
      }
      return userId;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load cart data: ${e.toString()}')),
        );
      }
      return userId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Error loading data: ${snapshot.error}")));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(body: Center(child: Text("Silakan login untuk melihat keranjang Anda.")));
        }

        final userId = snapshot.data!;

        return Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            List<CartItem> cartItems = cartProvider.items;
            double totalPrice = cartProvider.totalPrice;

            if (cartItems.isEmpty) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Cart',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                body: const Center(child: Text("Keranjang Anda kosong.")),
              );
            } else {
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
                          return Column(
                            children: [
                              _buildCartItem(context, cartItems[index], userId),
                              if (index < cartItems.length - 1)
                                Divider(
                                  height: 32,
                                  thickness: 1,
                                  color: Colors.grey[300],
                                  indent: 16,
                                  endIndent: 16,
                                ),
                            ],
                          );
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
                          // Pemanggilan _buildTotalRow yang benar
                          _buildTotalRow('Subtotal', 'Rp ${totalPrice.toStringAsFixed(0).replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (match) => '${match[1]}.',)}'),
                          _buildTotalRow('Shipping', 'Standard - Free'),
                          _buildTotalRow('Estimated Total', 'Rp ${totalPrice.toStringAsFixed(0).replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (match) => '${match[1]}.',)} + Tax', isBold: true), // Argumen isBold: true
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF041761),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutPage(
                                      cartItems: cartItems,
                                      totalPrice: totalPrice,
                                    ),
                                  ),
                                );
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

  // --- Pastikan _buildCartItem berada di dalam kelas _CartPageState ---
  Widget _buildCartItem(BuildContext context, CartItem cartItem, int userId) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    List<DropdownMenuItem<int>> quantityOptions = [
      DropdownMenuItem<int>(
        value: 0,
        child: Text("Remove", style: TextStyle(color: Colors.red[700])),
      ),
      for (int i = 1; i <= 100; i++)
        DropdownMenuItem<int>(
          value: i,
          child: Text("$i"),
        ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(cartItem.product.photoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: cartItem.quantity,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    onChanged: (int? newValue) async {
                      if (newValue != null) {
                        if (newValue == 0) {
                          try {
                            await _cartService.removeProductFromCart(userId, cartItem.product.id!);
                            cartProvider.removeItem(cartItem.product);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to remove item: ${e.toString()}')),
                            );
                          }
                        } else {
                          try {
                            await _cartService.updateProductQuantity(userId, cartItem.product.id!, newValue);
                            cartProvider.updateQuantity(cartItem.product, newValue);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to update quantity: ${e.toString()}')),
                            );
                          }
                        }
                      }
                    },
                    items: quantityOptions,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  cartItem.product.category,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Pindahkan harga ke paling kanan
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Remove button dihapus karena sudah di dropdown
                    // Tambahkan Spacer jika perlu lebih banyak kontrol spasi
                    // Spacer(), // Jika Anda ingin memisahkan harga lebih jauh dari nama produk
                    Text(
                      "Rp ${cartItem.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),(match) => '${match[1]}.',)}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Pastikan _buildTotalRow berada di dalam kelas _CartPageState ---
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