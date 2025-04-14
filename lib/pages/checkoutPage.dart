class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final paymentPhoneController = TextEditingController();

  String shippingOption = "free";
  String paymentMethod = "dana";

  void placeOrder() {
    final orderData = {
      "name": nameController.text,
      "address": addressController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "shipping": shippingOption,
      "payment_method": paymentMethod,
      "payment_phone": paymentPhoneController.text,
    };

    // Call API
    placeOrderAPI(orderData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Delivery Info
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: addressController, decoration: InputDecoration(labelText: "Address")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone Number")),

            SizedBox(height: 20),
            // Shipping
            ListTile(
              title: Text("Arrives Mon, 16 Dec - Fri, 20 Dec"),
              leading: Radio(value: "free", groupValue: shippingOption, onChanged: (val) => setState(() => shippingOption = val!)),
            ),
            ListTile(
              title: Text("Arrives Thu, 12 Dec - Mon, 16 Dec (Rp 350,000)"),
              leading: Radio(value: "express", groupValue: shippingOption, onChanged: (val) => setState(() => shippingOption = val!)),
            ),

            SizedBox(height: 20),
            // Payment
            ListTile(
              title: Text("Dana"),
              leading: Radio(value: "dana", groupValue: paymentMethod, onChanged: (val) => setState(() => paymentMethod = val!)),
            ),
            ListTile(
              title: Text("Transfer"),
              leading: Radio(value: "transfer", groupValue: paymentMethod, onChanged: (val) => setState(() => paymentMethod = val!)),
            ),
            TextField(controller: paymentPhoneController, decoration: InputDecoration(labelText: "Dana Phone Number")),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: placeOrder,
              child: Text("Place Order"),
            ),
          ],
        ),
      ),
    );
  }
}
