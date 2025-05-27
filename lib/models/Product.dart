class Product {
  final String name;
  final String brand;
  final String category;
  final String photoUrl;
  final double price;
  final int stock;
  final int? id;
  final String? createdOn;
  final String? updatedOn;

  Product({
    required this.name,
    required this.brand,
    required this.category,
    required this.photoUrl,
    required this.price,
    required this.stock,
    this.id,
    this.createdOn,
    this.updatedOn,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      brand: json['brand'],
      category: json['category'],
      photoUrl: json['photoUrl'],
      price: json['price']?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      id: json['id'],
      createdOn: json['createdOn'],
      updatedOn: json['updatedOn'],
    );
  }
}
