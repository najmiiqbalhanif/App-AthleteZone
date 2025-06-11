import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helloworld/presentation/pages/cart_provider.dart';
import '../../services/cartService.dart';
import '../../models/CartItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helloworld/presentation/pages/checkoutPayment.dart';

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

  // Fungsi baru untuk menampilkan pemilih kuantitas
  Future<int?> _showQuantityPicker(BuildContext context, int currentQuantity) async {
    final double itemHeight = 50; // Sesuaikan dengan itemExtent di ListWheelScrollView

    final FixedExtentScrollController scrollController =
    FixedExtentScrollController(initialItem: currentQuantity - 1);
    int selectedQuantity = currentQuantity; // Inisialisasi selectedQuantity

    return await showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        // Menggunakan StatefulBuilder untuk mengelola state lokal dari ListWheelScrollView
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateInner) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.45,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      "Remove",
                      style: TextStyle(color: Colors.red[700], fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      Navigator.pop(context, 0);
                    },
                  ),
                  const Divider(),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Garis indikator abu-abu terang di tengah, membingkai angka
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: itemHeight, // Tinggi garis sama dengan tinggi item
                              decoration: BoxDecoration(
                                color: Colors.grey[200], // Warna abu-abu terang
                                borderRadius: BorderRadius.circular(8), // Sudut melengkung
                              ),
                            ),
                          ),
                        ),
                        ListWheelScrollView.useDelegate(
                          controller: scrollController,
                          itemExtent: itemHeight, // Tinggi setiap item dalam list
                          perspective: 0.003,
                          diameterRatio: 1.5,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            // Perbarui selectedQuantity dan rebuild StatefulBuilder
                            setStateInner(() {
                              selectedQuantity = index + 1;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (BuildContext context, int index) {
                              final int qty = index + 1;
                              // Tentukan apakah item ini adalah yang sedang dipilih (berada di tengah)
                              final bool isSelected = (qty == selectedQuantity);

                              return Center(
                                child: Text(
                                  '$qty',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.blueAccent : Colors.grey[700], // Perubahan warna di sini
                                  ),
                                ),
                              );
                            },
                            childCount: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, selectedQuantity);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF041761),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem cartItem, int userId) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: IntrinsicHeight( // Tambahkan IntrinsicHeight agar Column anak bisa mengisi tinggi penuh
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Agar anak Column memenuhi tinggi Row
          children: [
            // Kolom Kiri: Gambar dan Qty Selector
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
                GestureDetector(
                  onTap: () async {
                    final int? selectedQuantity = await _showQuantityPicker(context, cartItem.quantity);

                    if (selectedQuantity != null) {
                      if (selectedQuantity == 0) {
                        try {
                          await _cartService.removeProductFromCart(userId, cartItem.product.id!);
                          cartProvider.removeItem(cartItem.product);
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to remove item: ${e.toString()}')),
                            );
                          }
                        }
                      } else if (selectedQuantity != cartItem.quantity) {
                        try {
                          await _cartService.updateProductQuantity(userId, cartItem.product.id!, selectedQuantity);
                          cartProvider.updateQuantity(cartItem.product, selectedQuantity);
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to update quantity: ${e.toString()}')),
                            );
                          }
                        }
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Qty ${cartItem.quantity}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Kolom Kanan: Detail Produk (Nama, Kategori, Harga)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Sejajarkan teks ke kiri
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Dorong elemen ke atas dan bawah
                children: [
                  // Bagian atas: Nama dan Kategori
                  Column(
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
                    ],
                  ),
                  // Bagian bawah: Harga
                  Align( // Gunakan Align untuk menempatkan harga di kanan bawah
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Rp ${cartItem.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),(match) => '${match[1]}.',)}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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