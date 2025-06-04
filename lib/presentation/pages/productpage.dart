import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'cartpage.dart';
import 'productPageDetail.dart';
import '../../models/Product.dart';
import '../../services/ProductService.dart';

class ProductPage extends StatefulWidget {
  final int? id;

  const ProductPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Product? product;
  bool isLoading = true;
  String _selectedSize = "Select Size";
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    fetchProductDetail();
  }

  void fetchProductDetail() async {
    try {
      Product fetchedProduct = await ProductService().getProductById(widget.id!);
      setState(() {
        product = fetchedProduct;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching product: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load product')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(product!.name),
        centerTitle: true,
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
              height: 350,
              child: Image.network(
                product!.photoUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.broken_image)),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                product!.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                product!.category,
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
                NumberFormat.currency(locale: 'id', symbol: 'Rp')
                    .format(product!.price),
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
                    onTap: () => _pageController.jumpToPage(0),
                  ),
                  const SizedBox(width: 8),
                  _ColorOption(
                    color: Colors.black,
                    isSelected: _currentPage == 1,
                    onTap: () => _pageController.jumpToPage(1),
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
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (BuildContext context) {
                            return _SizeSelectorSheet(
                              onSizeSelected: (size) {
                                setState(() {
                                  _selectedSize = size;
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side:
                        const BorderSide(color: Color(0xFF041761)),
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
                        backgroundColor: const Color(0xFF041761),
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
                        side:
                        const BorderSide(color: Color(0xFF041761)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child:
                      Text(_isFavorited ? "Favorited ❤︎" : "Favorite"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'DUMMY TEST',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.4),
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
                    color: const Color(0xFF041761),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
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
  final Function(String) onSizeSelected;

  const _SizeSelectorSheet({super.key, required this.onSizeSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> sizes =
    List.generate(10, (index) => 'EU ${38 + index}');

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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: sizes.map((size) {
              return GestureDetector(
                onTap: () => onSizeSelected(size),
                child: Container(
                  width: 80,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF041761)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(size, style: const TextStyle(fontSize: 16)),
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
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween =
      Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
