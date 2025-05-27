import 'package:flutter/material.dart';
import 'package:helloworld/presentation/pages/ordersPage.dart';
import 'package:helloworld/presentation/pages/profilepage.dart';
import '../../models/Payment.dart';
import '../../services/CheckoutService.dart';


void main() {
  runApp(MaterialApp(
    home: CheckoutPage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        onPrimary: Colors.white,
        secondary: Colors.blue,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900],
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.blue[900]!),
          foregroundColor: Colors.blue[900],
        ),
      ),
    ),
  ));
}

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  String firstName = '';
  String lastName = '';
  String address = '';
  String email = '';
  String phone = '';
  String? _selectedPaymentMethod = 'credit';

  bool isDelivery = true;
  String? selectedLocation;
  String? selectedTime;

  List<String> pickupLocations = ['Bandung Store', 'Jakarta Store'];
  List<String> pickupTimes = ['10:00 AM', '1:00 PM', '4:00 PM'];
  final checkoutService = CheckoutService(baseUrl: 'http://your-backend-url');

  List<PaymentItemDTO> cartItems = [
    PaymentItemDTO(
      name: 'Nike Air Zoom Pegasus 37',
      quantity: 1,
      price: 6098000,
      subTotal: 6098000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Text("AthleteZone",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            Spacer(),
            Icon(Icons.search, color: Colors.black),
            SizedBox(width: 20),
            Icon(Icons.shopping_cart_outlined, color: Colors.black),
            SizedBox(width: 20),
            IconButton(
              icon: Icon(Icons.account_circle_outlined, color: Colors.black),
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
          if (_formKey.currentState!.validate()) {
            if (_currentStep < 2) {
              setState(() => _currentStep += 1);
            }
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
                    child: Text('Continue', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                    ),
                  ),
                if (!isLastStep) SizedBox(width: 20),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text('Back', style: TextStyle(color: Colors.blue[900])),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: Text("1. Delivery Options"),
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
                            backgroundColor: isDelivery ? Colors.blue[900] : Colors.white,
                            side: BorderSide(color: Colors.blue[900]!),
                          ),
                          child: Text(
                            "Delivery",
                            style: TextStyle(
                              color: isDelivery ? Colors.white : Colors.blue[900],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isDelivery = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isDelivery ? Colors.blue[900] : Colors.white,
                            side: BorderSide(color: Colors.blue[900]!),
                          ),
                          child: Text(
                            "Pick Up",
                            style: TextStyle(
                              color: !isDelivery ? Colors.white : Colors.blue[900],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (isDelivery) ...[
                    TextFormField(
                      decoration: InputDecoration(labelText: "First Name"),
                      onChanged: (value) => firstName = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Last Name"),
                      onChanged: (value) => lastName = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Address"),
                      onChanged: (value) => address = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Email"),
                      onChanged: (value) => email = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Phone Number"),
                      onChanged: (value) => phone = value,
                    ),
                  ] else ...[
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Pickup Location"),
                      items: pickupLocations.map((location) {
                        return DropdownMenuItem(value: location, child: Text(location));
                      }).toList(),
                      onChanged: (value) => setState(() => selectedLocation = value),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Pickup Time"),
                      items: pickupTimes.map((time) {
                        return DropdownMenuItem(value: time, child: Text(time));
                      }).toList(),
                      onChanged: (value) => setState(() => selectedTime = value),
                    ),
                  ],
                ],
              ),
            ),
            isActive: _currentStep == 0,
            state: _currentStep == 0 ? StepState.editing : StepState.indexed,
          ),
          Step(
            title: Text("2. Payment"),
            content: Column(
              children: [
                RadioListTile(
                  title: Text("Credit Card"),
                  value: "credit",
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value.toString()),
                ),
                RadioListTile(
                  title: Text("PayPal"),
                  value: "paypal",
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value.toString()),
                ),
                RadioListTile(
                  title: Text("Cash on Delivery"),
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
            title: Text("3. Order Review"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Image.asset('assets/images/pegasus.jpeg', width: 80, height: 80),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nike Air Zoom Pegasus 37', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Size: 4.5'),
                              Text('Color: Indigo Haze/Purple Pulse'),
                              Text('Qty: 1'),
                              SizedBox(height: 5),
                              Text('£104.95', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Total: Rp6.098.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        // Contoh data payment, sesuaikan dengan data sebenarnya
                        final payment = PaymentDTO(
                          userId: 1, // ganti dengan user login sebenarnya
                          paymentMethod: _selectedPaymentMethod ?? 'credit',
                          address: address, // pastikan ini sudah diisi user
                          totalAmount: 6098000, // hitung total harga dari cart kamu
                        );

                        // Contoh list item, sesuaikan dengan keranjang yang sebenarnya
                        final items = [
                          PaymentItemDTO(
                            name: 'Nike Air Zoom Pegasus 37',
                            quantity: 1,
                            price: 6098000,
                            subTotal: 6098000,
                          ),
                        ];

                        // Panggil service untuk submit checkout (pastikan sudah buat CheckoutService)
                        await checkoutService.submitCheckout(payment, items);

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Order Confirmed"),
                            content: Text("Thank you for your purchase!"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => OrdersPage()),
                                  );
                                },
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to submit order')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: Text("Submit Order", style: TextStyle(color: Colors.white)),
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
