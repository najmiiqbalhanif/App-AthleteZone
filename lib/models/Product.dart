// lib/models/Product.dart

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
      name: json['name'] as String, // Pastikan cast ke String
      brand: json['brand'] as String, // Pastikan cast ke String
      category: json['category'] as String, // Pastikan cast ke String
      photoUrl: json['photoUrl'] as String, // Pastikan cast ke String
      price: (json['price'] as num).toDouble(), // Pastikan handle num to double
      stock: (json['stock'] as num).toInt(), // Pastikan handle num to int
      id: json['id'] as int?,
      createdOn: json['createdOn'] as String?,
      updatedOn: json['updatedOn'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'photoUrl': photoUrl,
      'price': price,
      'stock': stock,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }
}