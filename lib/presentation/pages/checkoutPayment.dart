import 'package:flutter/material.dart';
import 'package:helloworld/presentation/pages/ordersPage.dart';
import 'package:helloworld/presentation/pages/profilepage.dart';


void main() {
  runApp(MaterialApp(
    home: CheckoutPage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.light(
        primary: Colors.blue, // Stepper active color and borders
        onPrimary: Colors.white, // Text color for primary color buttons
        secondary: Colors.blue, // Color for radio, checkboxes, etc.
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900], // Dark blue for button background
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.blue[900]!), // Dark blue border for outlined buttons
          foregroundColor: Colors.blue[900], // Text color for outlined button
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Text(
              "AthleteZone",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
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
          if (_currentStep < 2) {
            setState(() => _currentStep += 1);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900], // Dark blue for Continue button
                  ),
                  child: Text('Continue', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.blue[900], // Dark blue for Back button
                    ),
                  ),
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900], // Dark blue background
                          ),
                          child: Text("Delivery", style: TextStyle(color: Colors.white)), // White text
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.blue[900]!), // Dark blue border
                            foregroundColor: Colors.blue[900], // Dark blue text
                          ),
                          child: Text("Pick Up"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
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
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: Text("PayPal"),
                  value: "paypal",
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: Text("Cash on Delivery"),
                  value: "cod",
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value.toString();
                    });
                  },
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          child: Image.asset(
                            'assets/images/pegasus.jpeg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nike Air Zoom Pegasus 37',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text('Size: 4.5'),
                              Text('Color: Indigo Haze/Purple Pulse'),
                              Text('Qty: 1'),
                              SizedBox(height: 5),
                              Text(
                                '£104.95',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
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
                  child: Text(
                    'Total: £104.95',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Order Confirmed"),
                          content: Text("Thank you for your purchase!"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Tutup dialog dulu
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900], // Dark blue background for Submit Order
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: Text("Submit Order", style: TextStyle(color: Colors.white)), // White text
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
