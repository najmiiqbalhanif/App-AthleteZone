import '../models/Product.dart'; // Pastikan path ini benar

class CartItem {
  Product product;  // Produk terkait dengan CartItem
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Menghitung total harga untuk CartItem (harga produk * kuantitas)
  double get totalPrice => product.price * quantity;

  // Metode untuk menambah kuantitas
  void incrementQuantity() {
    quantity++;
  }

  // Metode untuk mengurangi kuantitas
  void decrementQuantity() {
    if (quantity > 1) { // Pastikan kuantitas tidak kurang dari 1
      quantity--;
    }
  }

  // Pemetaan JSON ke CartItem
  // Saya merevisi factory constructor ini agar lebih fleksibel
  // dan mengasumsikan bahwa 'product' akan selalu ada dalam format yang bisa di-deserialize
  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Asumsi: JSON akan selalu memiliki struktur yang berisi product data
    // jika Anda menerima CartItem dari API backend (misalnya dari /api/cart/items)
    // Jika API Anda mengembalikan struktur datar tanpa nested 'product',
    // Anda perlu menyesuaikan deserialisasi di CartService, bukan di sini.
    return CartItem(
      // Asumsi 'product' adalah objek JSON yang perlu diuraikan oleh Product.fromJson
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] as int, // Casting eksplisit ke int
    );
  }

  // Metode untuk memperbarui kuantitas produk (tetap dipertahankan jika diperlukan)
  void updateQuantity(int newQuantity) {
    if (newQuantity >= 0) { // Pastikan kuantitas tidak negatif
      quantity = newQuantity;
    }
  }
}