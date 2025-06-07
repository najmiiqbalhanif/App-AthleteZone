import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'cartpage.dart';
import 'productPageDetail.dart';
import '../../models/Product.dart';
import '../../services/ProductService.dart';

// Dummy review data (moved here for global access or can be encapsulated)
final List<Map<String, dynamic>> reviews = [
  {
    'name': 'Akimilakuy76 • May 3, 2025',
    'rating': 5,
    'comment': 'Very comfortable and stylish! Definitely worth the price.',
  },
  {
    'name': 'Naiki • March 6, 2024',
    'rating': 4.5,
    'comment': 'The design is great, but I recommend sizing up.',
  },
  {
    'name': 'Riko • April 12, 2024',
    'rating': 5,
    'comment': 'Super comfortable and stylish. Worth every penny!',
  },
  {
    'name': 'Anita • May 2, 2024',
    'rating': 3.5,
    'comment': 'Nice color, but not as breathable as I expected.',
  },
  {
    'name': 'Dewi • March 28, 2024',
    'rating': 5,
    'comment': 'Perfect for running, very light and supportive.',
  },
  {
    'name': 'Hansen • April 18, 2024',
    'rating': 2,
    'comment': 'Too narrow for wide feet. Had to return.',
  },
  {
    'name': 'Mira • May 10, 2024',
    'rating': 4,
    'comment': 'Love the look! A bit stiff at first but breaks in nicely.',
  },
  {
    'name': 'Arga • March 15, 2024',
    'rating': 5,
    'comment': 'Amazing grip and comfort. Highly recommend for daily use.',
  },
  {
    'name': 'Tasya • April 25, 2024',
    'rating': 3.5,
    'comment': 'Good shoes, but the laces are too short.',
  },
  {
    'name': 'Reyhan • May 1, 2024',
    'rating': 4,
    'comment': 'Great value for the price. Stylish and practical.',
  },
  {
    'name': 'Lina • March 30, 2024',
    'rating': 5,
    'comment': 'Best pair I’ve bought in years. Super comfy!',
  }
];

// Variabel global untuk status review yang diperluas
bool _isReviewExpanded = false;

// Getter untuk jumlah review
int get reviewCount => reviews.length;

// Getter untuk rating rata-rata
double get averageRating {
  if (reviews.isEmpty) return 0.0;
  double raw = reviews.map((r) => r['rating'] as num).reduce((a, b) => a + b) / reviews.length;
  return (raw * 2).round() / 2; // round to nearest .5
}

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

  Future<void> addToCart(int userId, int productId) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/cart/add?userId=$userId&productId=$productId');

    try {
      // Simulate network delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      final response = await http.post(url);

      if (response.statusCode == 200) {
        _showAddedToBagOverlay(1); // Pass the total items, replace '2' with actual count
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add product")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _showAddedToBagOverlay(int totalItems) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // Use a Stack to overlay the checkmark and text
        return Stack(
          alignment: Alignment.center,
          children: [
            // This is the semi-transparent background that dims the content behind
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
              ),
            ),
            // The actual content of the dialog
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.black, // Color of the checkmark
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Added to Bag",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "($totalItems Item(s) Total)",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24), // Space between the main dialog and the "Adding to Bag" text
                Text(
                  "Adding to Bag",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white), // Text color for the "Adding to Bag"
                ),
              ],
            ),
          ],
        );
      },
    );

    // Optionally, dismiss the dialog after a few seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }


  // Function to build star rating display
  List<Widget> buildStarRating(double rating, {double size = 20}) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return [
      for (int i = 0; i < fullStars; i++)
        Icon(Icons.star, color: Colors.blueAccent, size: size),
      if (hasHalfStar) Icon(Icons.star_half, color: Colors.blueAccent, size: size),
      for (int i = 0; i < emptyStars; i++)
        Icon(Icons.star_border, color: Colors.blueAccent, size: size),
    ];
  }

  // Modified function to display share sheet from top
  void _showShareSheetFromTop(String productTitle, String productCategory) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[400], // Changed color from white to be visible
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        productTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        productCategory,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.message),
                      title: const Text('Message'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.more_horiz),
                      title: const Text('Other'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
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
            onPressed: () => _showShareSheetFromTop(product!.name, product!.category),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
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

            // Product Name
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

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Select Size Button
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
                        side: const BorderSide(color: Colors.blueAccent),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_selectedSize),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Add to Bag Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        int userId = 1; // Replace with actual active user ID
                        await addToCart(userId, product!.id!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Add to Bag"),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Favorite Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isFavorited = !_isFavorited;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.blueAccent),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child:
                      Text(_isFavorited ? "Favorited ❤" : "Favorite"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Product Info and Description (from Code 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "This product is excluded from all promotions and discounts.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Comfortable, durable, and timeless—it's number one for a reason. The classic '80s construction blends smooth leather with bold details for a style that works whether you're on the court or on the go.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "• Shown: White/White\n• Style: CW2288-111\n• Country/Region of Origin: India, Vietnam",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),

            // Link to product details (if more details exist)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(_createRoute());
                },
                child: Text(
                  "View Product Details\n",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            // Review Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _isReviewExpanded = expanded;
                    });
                  },
                  title: Row(
                    children: [
                      Text(
                        "Reviews",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "($reviewCount)",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.blueAccent[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...buildStarRating(averageRating),
                      const SizedBox(width: 4),
                      Icon(
                        _isReviewExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey[700],
                      ),
                    ],
                  ),
                  children: reviews.map((review) {
                    double rating = (review['rating'] as num).toDouble();
                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person, color: Colors.grey),
                          title: Text(review['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(children: buildStarRating(rating, size: 16)),
                              const SizedBox(height: 4),
                              Text(
                                review['comment'],
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
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
                    border: Border.all(color: Colors.blueAccent),
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