// services/CheckoutService.dart
import 'dart:convert';
import 'package:helloworld/models/user.dart'; // Make sure this is your User model
import 'package:http/http.dart' as http;
import '../models/Payment.dart'; // Ensure this points to your Payment DTOs

class CheckoutService {
  final String baseUrl;

  CheckoutService({required this.baseUrl});

  Future<void> submitCheckout(PaymentDTO payment, List<PaymentItemDTO> items) async {
    final url = Uri.parse('$baseUrl/api/checkoutpayment/submit');

    final body = {
      ...payment.toJson(), // This includes userId (mapped to 'id') and other payment details
      'paymentItems': items.map((item) => item.toJson()).toList(),
    };

    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body));

      if (response.statusCode != 200) {
        // Provide more specific error message from backend if available
        final errorBody = jsonDecode(response.body);
        throw Exception('Failed to submit checkout: ${errorBody['message'] ?? response.body}');
      }
    } catch (e) {
      throw Exception('Network error or failed to submit checkout: $e');
    }
  }

  Future<User> getUserById(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/users/$userId')); // Assuming API endpoint for user

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user: ${response.statusCode} - ${response.body}');
    }
  }
}