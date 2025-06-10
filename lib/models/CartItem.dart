import '../models/Product.dart';

class CartItem {
  Product product;  // Product terkait dengan CartItem
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Menghitung total harga untuk CartItem (harga produk * kuantitas)
  double get totalPrice => product.price * quantity;

  // Pemetaan JSON ke CartItem
  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Jika data 'product' ada di dalam JSON (response dengan nested 'product')
    if (json.containsKey('product')) {
      return CartItem(
        product: Product.fromJson(json['product']), // Ambil 'product' dari nested JSON
        quantity: json['quantity'],
      );
    } else {
      // Jika response tidak ada nested 'product', buat 'product' secara manual
      return CartItem(
        product: Product(
          id: json['id'],
          name: json['name'],
          photoUrl: json['photoUrl'],
          price: json['price']?.toDouble() ?? 0.0,
          category: json['category'],
          brand: json['brand'],
          stock: 0, // Default karena tidak ada di response
          createdOn: null,
          updatedOn: null,
        ),
        quantity: json['quantity'],
      );
    }
  }

  // Method untuk memperbarui kuantitas produk
  void updateQuantity(int newQuantity) {
    quantity = newQuantity;
  }
}