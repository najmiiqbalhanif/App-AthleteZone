import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Product.dart'; // Pastikan path ini benar ke model Product Anda

class FavoriteService {
  // Metode untuk menghasilkan kunci unik berdasarkan userId
  String _getFavoriteKey(int userId) {
    return 'user_favorites_$userId';
  }

  // Menyimpan daftar produk favorit untuk user tertentu
  Future<void> saveFavorites(int userId, List<Product> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final String favoriteKey = _getFavoriteKey(userId); // Dapatkan kunci unik

    // Konversi List<Product> menjadi List<Map<String, dynamic>>
    List<String> favoriteJson = favorites.map((product) => json.encode(product.toJson())).toList();
    await prefs.setStringList(favoriteKey, favoriteJson);
  }

  // Mendapatkan daftar produk favorit untuk user tertentu
  Future<List<Product>> getFavorites(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final String favoriteKey = _getFavoriteKey(userId); // Dapatkan kunci unik

    List<String>? favoriteJsonList = prefs.getStringList(favoriteKey);
    if (favoriteJsonList == null) {
      return [];
    }
    // Konversi List<String> JSON kembali menjadi List<Product>
    return favoriteJsonList.map((jsonString) => Product.fromJson(json.decode(jsonString))).toList();
  }

  // Menambah/menghapus produk dari daftar favorit untuk user tertentu
  Future<bool> toggleFavorite(int userId, Product product) async {
    List<Product> favorites = await getFavorites(userId); // Ambil favorit user ini
    bool isFavorited = favorites.any((favProduct) => favProduct.id == product.id);

    if (isFavorited) {
      // Hapus dari favorit
      favorites.removeWhere((favProduct) => favProduct.id == product.id);
      print('Product removed from favorites for user $userId: ${product.name}');
    } else {
      // Tambah ke favorit
      favorites.add(product);
      print('Product added to favorites for user $userId: ${product.name}');
    }
    await saveFavorites(userId, favorites); // Simpan favorit user ini
    return !isFavorited; // Mengembalikan status favorit terbaru
  }

  // Memeriksa apakah produk sudah ada di favorit untuk user tertentu
  Future<bool> isProductFavorited(int userId, Product product) async {
    List<Product> favorites = await getFavorites(userId); // Ambil favorit user ini
    return favorites.any((favProduct) => favProduct.id == product.id);
  }
}