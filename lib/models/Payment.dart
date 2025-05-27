class PaymentItemDTO {
  String name;
  int quantity;
  double price;
  double subTotal;

  PaymentItemDTO({
    required this.name,
    required this.quantity,
    required this.price,
    required this.subTotal,
  });

  Map<String, dynamic> toJson() => {
    'productName': name,
    'quantity': quantity,
    'price': price,
    'subTotal': subTotal,
  };
}

class PaymentDTO {
  int userId;
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
