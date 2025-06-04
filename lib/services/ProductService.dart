import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Product.dart';

class ProductService {
  final String baseUrl = 'http://10.0.2.2:8080/api/shoppage'; // IP untuk emulator

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/get'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<Product> products = jsonList.map((jsonItem) => Product.fromJson(jsonItem)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> getProductById(int id) async {
    final String baseUrl = 'http://10.0.2.2:8080/api/productpage/get/$id';
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Product.fromJson(jsonData);
    } else {
      throw Exception('Failed to load product with id $id');
    }
  }
}
