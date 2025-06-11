import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'cartpage.dart';
import 'productPageDetail.dart';
import '../../models/Product.dart';
import '../../services/ProductService.dart';
import '../../services/FavoriteService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:helloworld/presentation/pages/cart_provider.dart';
import '../../models/CartItem.dart'; // <--- PASTIKAN INI ADA
import 'package:url_launcher/url_launcher.dart';

// Fungsi async untuk dapatkan userId dari SharedPreferences
Future<int?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('userId')) {
    return prefs.getInt('userId');
  }
  return null;
}

// Dummy review data (tetap sama)
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

bool _isReviewExpanded = false;
int get reviewCount => reviews.length;
double get averageRating {
  if (reviews.isEmpty) return 0.0;
  double raw = reviews.map((r) => r['rating'] as num).reduce((a, b) => a + b) / reviews.length;
  return (raw * 2).round() / 2;
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
  final FavoriteService _favoriteService = FavoriteService();
  int? _currentUserId;

  static const int MAX_QUANTITY_PER_ITEM = 10;
  bool _isAddingToCart = false; // <--- Variabel baru untuk melacak status penambahan

  @override
  void initState() {
    super.initState();
    _initializeProductAndFavorites();
  }

  Future<void> _initializeProductAndFavorites() async {
    _currentUserId = await getUserId();
    if (_currentUserId == null) {
      print('User is not logged in. Cannot fetch favorites.');
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to use favorites.')),
        );
      }
      setState(() {
        isLoading = false;
      });
      return;
    }
    fetchProductDetail();
  }

  void fetchProductDetail() async {
    try {
      Product fetchedProduct = await ProductService().getProductById(widget.id!);
      bool favorited = await _favoriteService.isProductFavorited(_currentUserId!, fetchedProduct);
      setState(() {
        product = fetchedProduct;
        _isFavorited = favorited;
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
    if (_isAddingToCart) return; // <--- Cegah panggilan ganda jika sedang dalam proses

    setState(() {
      _isAddingToCart = true; // Aktifkan flag saat proses dimulai
    });

    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      CartItem? existingCartItem;
      for (var item in cartProvider.items) {
        if (item.product.id == productId) {
          existingCartItem = item;
          break;
        }
      }

      if (existingCartItem != null && existingCartItem.quantity >= MAX_QUANTITY_PER_ITEM) {
        if (mounted) {
          _showQuantityFullNotification();
        }
        return; // Hentikan proses jika sudah mencapai batas
      }

      int quantityToRequest = 1; // Selalu minta backend untuk menambah 1

      // Jika backend Anda HANYA mendukung "add 1", maka logic berikut ini benar.
      // Jika backend Anda bisa "mengupdate kuantitas", maka Anda bisa mengirim quantityToRequest = existingCartItem.quantity + 1;
      // Namun, karena ada masalah penambahan banyak, kita akan asumsikan backend Anda menambahkan 1 setiap kali API ini dipanggil.

      final url = Uri.parse('http://10.0.2.2:8080/api/cart/add?userId=$userId&productId=$productId'); // <--- Hapus parameter &quantity jika backend hanya tambah 1

      // Hapus Future.delayed ini, ini bisa menyebabkan masalah double-tap
      // await Future.delayed(const Duration(milliseconds: 500));

      final response = await http.post(url);

      if (response.statusCode == 200) {
        // Karena backend hanya menambah 1, kita juga hanya menambah 1 di frontend
        cartProvider.addItem(product!); // Menggunakan addItem yang menambah 1 atau membuat baru
        _showAddedToBagOverlay(cartProvider.totalItems);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add product")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false; // Nonaktifkan flag setelah proses selesai (baik berhasil/gagal)
        });
      }
    }
  }

  void _showQuantityFullNotification() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text(
            "Quantity Full",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                "You've reached the maximum quantity for this item in your cart.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 18, // <-- PERBESAR UKURAN FONT DI SINI
                      fontWeight: FontWeight.bold, // Opsional: bisa ditambahkan agar lebih menonjol
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showAddedToBagOverlay(int totalItems) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
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
                        color: Colors.black,
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Added to Cart",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$totalItems Item(s) Total",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Adding to Cart",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

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

  void _showShareSheetFromTop(String productTitle, String productCategory, String productId) {
    final String productLink = 'https://your_app_domain.com/products/$productId?name=${Uri.encodeComponent(productTitle)}';

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
                            color: Colors.grey[400],
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
                      onTap: () async {
                        Navigator.pop(context);
                        final Uri smsLaunchUri = Uri(
                          scheme: 'sms',
                          queryParameters: <String, String>{
                            'body': productLink,
                          },
                        );

                        if (await canLaunchUrl(smsLaunchUri)) {
                          await launchUrl(smsLaunchUri);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not launch messaging app.')),
                          );
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.copy),
                      title: const Text('Copy Link'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Implement actual copy to clipboard using 'package:flutter/services.dart'
                        // import 'package:flutter/services.dart';
                        // Clipboard.setData(ClipboardData(text: productLink));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link copied to clipboard')),
                        );
                        print('Link copied (simulasi): $productLink');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.more_horiz),
                      title: const Text('Other'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        Navigator.pop(context);
                        // TODO: Implement actual share using 'package:share_plus'
                        // import 'package:share_plus/share_plus.dart';
                        // Share.share(productLink, subject: productTitle);
                        print('Trying to share via other apps (simulasi): $productLink');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening share options (simulasi)...')),
                        );
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
    if (isLoading || _currentUserId == null) {
      return Scaffold(
        body: Center(
          child: _currentUserId == null
              ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Please log in to view product details and use favorites.', textAlign: TextAlign.center,),
            ],
          )
              : const CircularProgressIndicator(),
        ),
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
            onPressed: () => _showShareSheetFromTop(product!.name, product!.category, product!.id.toString()),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                product!.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

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
                        side: const BorderSide(color: Colors.blueAccent),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_selectedSize),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: ElevatedButton(
                      // Nonaktifkan tombol saat _isAddingToCart true
                      onPressed: _isAddingToCart ? null : () async {
                        if (_currentUserId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please log in to add to cart.')),
                          );
                          return;
                        }
                        await addToCart(_currentUserId!, product!.id!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isAddingToCart
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Text("Add to Cart"),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        if (product != null && _currentUserId != null) {
                          bool newFavoriteStatus = await _favoriteService.toggleFavorite(_currentUserId!, product!);
                          setState(() {
                            _isFavorited = newFavoriteStatus;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isFavorited ? '${product!.name} added to favorites!' : '${product!.name} removed from favorites!',
                              ),
                            ),
                          );
                        } else if (_currentUserId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please log in to add to favorites.')),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.blueAccent),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isFavorited ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorited ? Colors.red : Colors.blueAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(_isFavorited ? "Favorited" : "Favorite"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

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