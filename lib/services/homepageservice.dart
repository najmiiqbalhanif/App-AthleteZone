import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class Homepageservice {
  static const String baseUrl = 'http://10.0.2.2:8080'; // Untuk Android Emulator
  static const String endpoint = '/api/user/homepage-products';

  static Future<List<Product>> fetchHomepageProducts() async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}