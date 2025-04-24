import 'package:flutter/material.dart';

class productPageDetail extends StatelessWidget {
  const productPageDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail"),
        centerTitle: true, // Tambahkan ini
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              "Stand out in your Sunday best in this special Victory Tour 4. A paisley pattern and floral accents are clean enough for an afternoon round. And we added our Nike-only Flyplate technology. It's designed to flex when you walk and stiffen when swinging, so you can stroll in comfort and rip away from wherever your ball lands",
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              "Swing and walk",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Our Nike-only Flyplate technology is flexible horizontally (soft for walking) and stiff vertically (for swinging)",
            ),
            SizedBox(height: 16),
            Text(
              "All-round support",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Inspired by a seat-belt harness, our internal Dynamic Fit system gives you support right where you need it. The Cushlon foam midsole provides the right level of comfort and stability",
            ),
            SizedBox(height: 16),
            Text(
              "Premium upper",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "The upper is made from soft, supple full-grain leather with a slightly pebbled texture Better Fit Listening to our athletes' feedback, we came up with a new frame for a better fit and shape compared with the Victory Tour 3. The internal foam collar offers sneaker-like comfort.",
            ),
            SizedBox(height: 16),
            Text(
              "Better Fit",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Listening to our athletes' feedback, we came up with a new frame for a better fit and shape compared with the Victory Tour 3. The internal foam collar offers sneaker-like comfort.",
            ),
            SizedBox(height: 16),
            Text(
              "Great grip",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "A two-pod outsole comes with a nine-spike traction pattern, giving you optimal grip when the weather gets dicey.",
            ),
          ],
        ),
      ),
    );
  }
}
