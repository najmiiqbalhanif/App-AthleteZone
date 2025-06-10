import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/CartItem.dart';
import '../services/ProductService.dart';

class CartService {
  final String baseUrl = 'http://10.0.2.2:8080/api/cart';
  final ProductService productService = ProductService();

  List<CartItem> _cartItems = [];

  // Getter untuk cartItems (agar tidak bisa diubah langsung dari luar)
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  // Mendapatkan semua CartItems berdasarkan userId
  Future<List<CartItem>> getCartItems(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/items/$userId'));

    if (response.statusCode == 200) {
      try {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<CartItem> fetchedItems = jsonList.map((jsonItem) => CartItem.fromJson(jsonItem)).toList();
        _cartItems = fetchedItems;
        return fetchedItems;
      } catch (e) {
        print('Error decoding JSON: $e');
        throw Exception('Failed to parse cart items');
      }
    } else {
      print('Failed to load cart items. Status Code: ${response.statusCode}');
      throw Exception('Failed to load cart items');
    }
  }

  // Menghitung total harga dari semua item dalam keranjang
  double getTotalPrice() {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}