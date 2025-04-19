import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Orders',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Column(
        children: [
          // Daftar Produk
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildOrdersItem(context, 'assets/images/caps_nike.png', status: 'paid'),
                const Divider(),
                _buildOrdersItem(context, 'assets/images/caps_adidas.png', status: 'on process'),
                const Divider(),
                _buildOrdersItem(context, 'assets/images/shoes1.png', status: 'done'),
              ],
            ),
          ),

          // Total dan Checkout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrdersItem(BuildContext context, String imagePath,
      {String status = 'paid'}) {
    // Tentukan warna berdasarkan status
    Color statusColor;
    switch (status) {
      case 'on process':
        statusColor = Colors.orange;
        break;
      case 'done':
        statusColor = Colors.green;
        break;
      case 'paid':
      default:
        statusColor = Colors.blue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Gambar & Qty ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Qty: 2",
                style: const TextStyle(
                    color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Detail Produk dan Spacer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nike Air Max Dn8",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Men's Shoes\nWhite",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "42",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Harga & Status di kanan bawah
          SizedBox(
            height: 100,
            width: 100,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      border: Border.all(color: statusColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Rp6.098.000",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}