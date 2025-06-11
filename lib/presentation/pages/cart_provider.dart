import 'package:flutter/material.dart';
import '/models/Product.dart';
import '/models/CartItem.dart'; // Penting: Pastikan ini mengacu pada model CartItem yang benar

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalItems {
    int total = 0;
    for (var item in _items) {
      total += item.quantity;
    }
    return total;
  }

  // Pastikan getter totalPrice ada di sini
  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item.totalPrice; // Asumsi CartItem memiliki getter totalPrice
    }
    return total;
  }

  void addItem(Product product) {
    int index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].incrementQuantity();
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  // Pastikan addExistingItem ada di sini
  void addExistingItem(Product product, int quantity) {
    int index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  // Pastikan increaseQuantity ada di sini
  void increaseQuantity(Product product) {
    int index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].incrementQuantity();
      notifyListeners();
    }
  }

  // Pastikan decreaseQuantity ada di sini
  void decreaseQuantity(Product product) {
    int index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].decrementQuantity();
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Pastikan removeItem ada di sini
  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  // Pastikan clearCart ada di sini
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // di helloworld/presentation/pages/cart_provider.dart
  void updateQuantity(Product product, int newQuantity) {
    final existingItemIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity = newQuantity;
      notifyListeners();
    }
  }

}