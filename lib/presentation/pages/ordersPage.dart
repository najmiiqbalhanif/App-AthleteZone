import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<Map<String, dynamic>> orders = [
    {
      'orderId': 'ORD001',
      'date': '2024-05-30',
      'totalAmount': 1200000,
      'items': [
        {
          'name': 'Nike Cap',
          'image': 'assets/images/caps_nike.png',
          'qty': 2,
          'status': 'paid',
          'price': 300000,
          'size': 'L',
          'description': "Men's Cap\nBlack",
        },
        {
          'name': 'Nike Socks',
          'image': 'assets/images/shoes1.png',
          'qty': 1,
          'status': 'paid',
          'price': 600000,
          'size': 'Free Size',
          'description': "Socks\nWhite",
        },
      ]
    },
    {
      'orderId': 'ORD002',
      'date': '2024-06-01',
      'totalAmount': 899000,
      'items': [
        {
          'name': 'Adidas Cap',
          'image': 'assets/images/caps_adidas.png',
          'qty': 1,
          'status': 'on process',
          'price': 899000,
          'size': 'M',
          'description': "Men's Cap\nBlue",
        },
      ]
    },
  ];

  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

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
      body: ListView.builder(
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
                      "Order ID: ${order['orderId']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Date: ${order['date']}")
                  ],
                ),
                Text(
                  currencyFormat.format(order['totalAmount']),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            children: order['items'].map<Widget>((item) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                    child: _buildOrderItem(context, item),
                  ),
                  const Divider(),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, Map<String, dynamic> item) {
    Color statusColor;
    switch (item['status']) {
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

    return Row(
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
                  image: AssetImage(item['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Qty: ${item['qty']}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
                item['name'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                item['description'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Size: ${item['size']}",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
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
                    item['status'].toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  currencyFormat.format(item['price']),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}