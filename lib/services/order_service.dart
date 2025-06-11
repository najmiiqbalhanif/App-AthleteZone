import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_dto.dart'; // Buat model ini jika belum ada

class OrderService {
  final String baseUrl;

  OrderService({required this.baseUrl});

  Future<List<OrderDTO>> fetchAllOrders() async {
    final url = Uri.parse('$baseUrl/api/orders'); // Sesuaikan dengan endpoint yang Anda buat
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => OrderDTO.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      throw Exception('Network error or failed to fetch orders: $e');
    }
  }

  Future<List<OrderDTO>> fetchOrdersByUserId(int userId) async {
    final url = Uri.parse('$baseUrl/api/orders/user/$userId'); // Endpoint untuk user tertentu
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => OrderDTO.fromJson(data)).toList();
      } else if (response.statusCode == 404) {
        // Jika tidak ada order untuk user ini, mungkin mengembalikan 404
        return [];
      }
      else {
        throw Exception('Failed to load user orders: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching user orders: $e');
      throw Exception('Network error or failed to fetch user orders: $e');
    }
  }
}