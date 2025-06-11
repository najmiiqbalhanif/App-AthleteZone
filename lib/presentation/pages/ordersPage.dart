import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Untuk mendapatkan userId
import '../../models/order_dto.dart'; // Import OrderDTO yang baru dibuat
import '../../services/order_service.dart'; // Import OrderService yang baru dibuat

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<OrderDTO> orders = []; // Ganti dengan list OrderDTO
  bool isLoading = true;
  String? errorMessage;
  final OrderService orderService = OrderService(baseUrl: 'http://10.0.2.2:8080'); // Inisialisasi service

  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // Panggil saat initState
  }

  Future<void> _fetchOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId'); // Ambil userId dari SharedPreferences

      if (userId == null) {
        setState(() {
          isLoading = false;
          errorMessage = "User not logged in. Please log in to view your orders.";
        });
        return;
      }

      // Ambil order berdasarkan userId (lebih relevan)
      final fetchedOrders = await orderService.fetchOrdersByUserId(userId);
      // Atau jika ingin semua order: final fetchedOrders = await orderService.fetchAllOrders();

      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load orders. Please try again later. ($e)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchOrders,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      )
          : orders.isEmpty
          ? const Center(child: Text("No orders found."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order ID: ${order.id}", // Menggunakan order.id
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Date: ${order.createdOn.split('T')[0]}") // Mengambil tanggal saja
                  ],
                ),
                Text(
                  currencyFormat.format(order.totalAmount), // Menggunakan order.totalAmount
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            children: [
              // Karena cartSummary adalah String, kita akan menampilkannya langsung
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment Method: ${order.paymentMethod}'),
                    Text('Payment Status: ${order.paymentStatus}'),
                    Text('Address: ${order.address}'),
                    const Divider(),
                    Text(
                      'Items: ${order.cartSummary}', // Menampilkan ringkasan cart
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              // Jika Anda ingin menampilkan setiap item secara detail, Anda perlu mengubah OrderDTO
              // di backend untuk menyertakan daftar PaymentItemDTO di dalamnya.
              // Saat ini OrderDTO di backend hanya memiliki `cartSummary` (String).
              // Untuk sementara, kita akan tampilkan `cartSummary` sebagai ringkasan.
            ],
          );
        },
      ),
    );
  }
}