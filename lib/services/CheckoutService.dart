import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Payment.dart';

class CheckoutService {
  final String baseUrl;

  CheckoutService({required this.baseUrl});

  Future<void> submitCheckout(PaymentDTO payment, List<PaymentItemDTO> items) async {
    final url = Uri.parse('$baseUrl/api/checkoutpayment/submit');

    final body = {
      ...payment.toJson(),
      'paymentItems': items.map((item) => item.toJson()).toList(),
    };

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body));

    if (response.statusCode != 200) {
      throw Exception('Failed to submit checkout: ${response.body}');
    }
  }
}
