// payment.dart
class PaymentItemDTO {
  String name;
  int quantity;
  double price; // Add product price
  double subTotal;

  PaymentItemDTO({
    required this.name,
    required this.quantity,
    required this.price,
    required this.subTotal,
  });

  Map<String, dynamic> toJson() => {
    'name': name, // Should match backend DTO field name
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
    // Backend's PaymentDTO has 'id', 'username', 'paymentMethod', 'address', 'totalAmount'.
    // Assuming backend's 'id' field is mapped from 'userId' in Flutter's DTO,
    // and 'username' is not directly passed but inferred or can be added from user data.
    'id': userId, // Mapping Flutter's userId to backend's 'id' field in PaymentDTO
    // 'username': '...', // If you need to send username, fetch it from User model
    'paymentMethod': paymentMethod,
    'address': address,
    'totalAmount': totalAmount,
  };
}