// payment.dart
class PaymentItemDTO {
  final int userId;
  String name;
  int quantity;
  double price; // Add product price
  double subTotal;

  PaymentItemDTO({
    required this.userId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.subTotal,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'productName': name,
    'quantity': quantity,
    'price': price,
    'subTotal': subTotal,
  };

}

class PaymentDTO {
  int userId; // This is the user ID from SharedPreferences
  String paymentMethod;
  String address;
  double totalAmount;

  PaymentDTO({
    required this.userId,
    required this.paymentMethod,
    required this.address,
    required this.totalAmount,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'paymentMethod': paymentMethod,
    'address': address,
    'totalAmount': totalAmount,
  };

}