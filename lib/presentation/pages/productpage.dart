import 'package:flutter/material.dart';
import 'cartpage.dart';
import 'productPageDetail.dart';

class ProductDetailPage extends StatefulWidget {
  final List<String> imageUrls;
  final String title;
  final String category;
  final String price;

  const ProductDetailPage({
    Key? key,
    required this.imageUrls,
    required this.title,
    required this.category,
    required this.price,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String _selectedSize = "Select Size"; // Variabel untuk menyimpan ukuran yang dipilih
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isFavorited = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true, // Tambahkan ini
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.imageUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                    widget.imageUrls[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.imageUrls.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 12 : 8,
                    height: _currentPage == index ? 12 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.black : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.category,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.price,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Color options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _ColorOption(
                    color: Colors.white,
                    isSelected: _currentPage == 0,
                    onTap: () {
                      _pageController.jumpToPage(0);
                    },
                  ),
                  const SizedBox(width: 8),
                  _ColorOption(
                    color: Colors.black,
                    isSelected: _currentPage == 1,
                    onTap: () {
                      _pageController.jumpToPage(1);
                    },
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _pageController.jumpToPage(2);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(8),
                        color: _currentPage == 2
                            ? Colors.black
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.color_lens, size: 20, color: Colors.blueAccent),
                          const SizedBox(width: 4),
                          Text(
                            "Design Your Own",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (BuildContext context) {
                            return _SizeSelectorSheet(
                              onSizeSelected: (size) {
                                setState(() {
                                  _selectedSize = size;
                                });
                                Navigator.pop(context);
                              }
                            );
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.blue),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_selectedSize),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Add to Bag"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isFavorited = !_isFavorited;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.blue),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_isFavorited ? "Favorited ❤︎" : "Favorite"),
                    ),

                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Info, Description, Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "This product is excluded from all promotions and discounts.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Comfortable, durable and timeless—it's number one for a reason. "
                    "The classic '80s construction pairs smooth leather with bold "
                    "details for style that tracks whether you're on the court or on the go.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "• Shown: White/White\n"
                    "• Style: CW2288-111\n"
                    "• Country/Region of Origin: India, Vietnam",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(_createRoute());
                  },
                  child: Text(
                    "View Product Details",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _SizeSelectorSheet extends StatelessWidget {
  final Function(String) onSizeSelected; // Callback untuk mengirim ukuran yang dipilih

  const _SizeSelectorSheet({super.key, required this.onSizeSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> sizes = List.generate(10, (index) => 'EU ${38 + index}');

    return Container(
      padding: const EdgeInsets.all(16),
      height: 340,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            "Select Size",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: sizes.map((size) {
              return GestureDetector(
                onTap: () {
                  onSizeSelected(size); // Panggil callback dengan ukuran yang dipilih
                },
                child: Container(
                  width: 80, // Ukuran simetris
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    size,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}



Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    const productPageDetail(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // slide from right
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

