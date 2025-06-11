import 'package:flutter/material.dart';
import 'package:helloworld/presentation/pages/profilepage.dart';
import '../../models/Payment.dart';
import '../../services/CheckoutService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/CartItem.dart';
import '../../models/user.dart';
import '../mainLayout.dart';
import '../../services/notification_service.dart';

String fullName = '';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalPrice;

  const CheckoutPage({
    Key? key,
    required this.cartItems,
    required this.totalPrice,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  String? _selectedPaymentMethod = 'credit';

  bool isDelivery = true;
  String? selectedLocation;
  String? selectedTime;

  List<String> pickupLocations = ['Bandung Store', 'Jakarta Store'];
  List<String> pickupTimes = ['10:00 AM', '1:00 PM', '4:00 PM'];
  final checkoutService = CheckoutService(baseUrl: 'http://10.0.2.2:8080');

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId != null) {
      try {
        final User user = await checkoutService.getUserById(userId);
        setState(() {
          _fullNameController.text = user.fullname;
          _emailController.text = user.email;
        });
      } catch (e) {
        print('Error loading user data: $e');
        // Optionally show a snackbar or error message
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            const Text(
              "AthleteZone",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            const Icon(Icons.search, color: Colors.black),
            const SizedBox(width: 20),
            const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.account_circle_outlined, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_formKey.currentState!.validate()) {
              setState(() {
                if (_currentStep < 2) _currentStep += 1;
              });
            }
          } else if (_currentStep < 2) {
            setState(() => _currentStep += 1);
          } else {
            // This is the last step, handle submit order here if not already done in the button
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        controlsBuilder: (context, details) {
          final isLastStep = _currentStep == 2;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                if (!isLastStep)
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                    ),
                    child: const Text('Continue', style: TextStyle(color: Colors.white)),
                  ),
                if (!isLastStep) const SizedBox(width: 20),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text('Back', style: TextStyle(color: Colors.blue[900])),
                ),
                // For the last step, the submit button is inside the step content
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text("1. Delivery Options"),
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isDelivery = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDelivery ? const Color(0xFF041761) : Colors.white,
                            side: const BorderSide(color: Color(0xFF041761)),
                          ),
                          child: Text(
                            "Delivery",
                            style: TextStyle(
                              color: isDelivery ? Colors.white : const Color(0xFF041761),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isDelivery = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isDelivery ? const Color(0xFF041761) : Colors.white,
                            side: const BorderSide(color: Color(0xFF041761)),
                          ),
                          child: Text(
                            "Pick Up",
                            style: TextStyle(
                              color: !isDelivery ? Colors.white : const Color(0xFF041761),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (isDelivery) ...[
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(labelText: "Full Name"),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: "Address"),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ] else ...[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Pickup Location"),
                      value: selectedLocation,
                      items: pickupLocations.map((location) {
                        return DropdownMenuItem(value: location, child: Text(location));
                      }).toList(),
                      onChanged: (value) => setState(() => selectedLocation = value),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Pickup Time"),
                      value: selectedTime,
                      items: pickupTimes.map((time) {
                        return DropdownMenuItem(value: time, child: Text(time));
                      }).toList(),
                      onChanged: (value) => setState(() => selectedTime = value),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ],
                ],
              ),
            ),
            isActive: _currentStep == 0,
            state: _currentStep == 0 ? StepState.editing : StepState.indexed,
          ),
          Step(
            title: const Text("2. Payment"),
            content: Column(
              children: [
                RadioListTile(
                  title: const Text("Credit Card"),
                  value: "credit",
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value.toString()),
                ),
                RadioListTile(
                  title: const Text("PayPal"),
                  value: "paypal",
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value.toString()),
                ),
                RadioListTile(
                  title: const Text("Cash on Delivery"),
                  value: "cod",
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value.toString()),
                ),
              ],
            ),
            isActive: _currentStep == 1,
            state: _currentStep == 1 ? StepState.editing : StepState.indexed,
          ),
          Step(
            title: const Text("3. Order Review"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Order Summary:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                ...widget.cartItems.map((item) => Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Image.network(item.product.photoUrl, width: 80, height: 80, fit: BoxFit.cover),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Qty: ${item.quantity}'),
                              const SizedBox(height: 5),
                              Text(
                                'Rp ${item.totalPrice.toStringAsFixed(0).replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                      (match) => '${match[1]}.',
                                )}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total: Rp ${widget.totalPrice.toStringAsFixed(0).replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (match) => '${match[1]}.',
                    )}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!isDelivery && (selectedLocation == null || selectedTime == null)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select pickup location and time.')),
                        );
                        return;
                      }

                      final prefs = await SharedPreferences.getInstance();
                      final userId = prefs.getInt('userId');

                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User not logged in.')),
                        );
                        return;
                      }

                      try {
                        final payment = PaymentDTO(
                          userId: userId,
                          paymentMethod: _selectedPaymentMethod ?? 'credit',
                          address: isDelivery ? _addressController.text : (selectedLocation ?? 'N/A'),
                          totalAmount: widget.totalPrice,
                        );

                        final items = widget.cartItems.map((cartItem) {
                          // Pastikan cartItem.product dan cartItem.product.id tidak null
                          if (cartItem.product == null || cartItem.product.id == null) {
                            throw Exception('Product ID is null for item: ${cartItem.product.name}');
                          }
                          return PaymentItemDTO(
                            userId: userId,
                            name: cartItem.product.name,
                            quantity: cartItem.quantity,
                            price: cartItem.product.price,
                            subTotal: cartItem.totalPrice,
                          );
                        }).toList();

                        print("Submitting checkout...");
                        await checkoutService.submitCheckout(payment, items);
                        print("Checkout submitted!");

                        NotificationService.showNotification(
                          title: 'Order Diterima!',
                          body: 'Pesananmu berhasil disubmit. Terima kasih sudah berbelanja.',
                          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                          payload: 'order_success', // Payload sudah bisa dilewatkan
                        );

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Order Confirmed"),
                            content: const Text("Thank you for your purchase!"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const MainLayout(initialIndex: 2)),
                                        (Route<dynamic> route) => false,
                                  );
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        print('Checkout submission failed: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to submit order: $e')),
                        );
                        // Penting: Jika ada error, notifikasi tidak akan muncul.
                        // Pastikan backend tidak mengembalikan ID null.
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF041761),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: const Text("Submit Order", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            isActive: _currentStep == 2,
          ),
        ],
      ),
    );
  }
}