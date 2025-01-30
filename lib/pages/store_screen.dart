import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:vetroxstore/pages/buy_now_screen.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:vetroxstore/pages/product_details_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<Map<String, dynamic>> products = []; // Change to dynamic type
  String token = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    const url = 'https://votexs.onrender.com/products';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> productList = data["products"];

      setState(() {
        products = productList
            .map((product) => {
                  "id": product["productId"],
                  "name": product["productName"],
                  "price": product["price"].toString(),
                  "image": product["imageUrl"],
                  "description": product["description"],
                  "benefits": product["benefits"] ?? [],
                })
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog("Failed to fetch products");
    }
  }

  void _addToCart(Map<String, dynamic> product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];

    bool isProductInCart = cart.any((item) {
      Map<String, dynamic> cartItem = json.decode(item);
      return cartItem['id'] == product['id'];
    });

    if (!isProductInCart) {
      product['quantity'] = 1;
      cart.add(json.encode(product));
    } else {
      cart = cart.map((item) {
        Map<String, dynamic> cartItem = json.decode(item);
        if (cartItem['id'] == product['id']) {
          cartItem['quantity'] = (cartItem['quantity'] ?? 0) + 1;
        }
        return json.encode(cartItem);
      }).toList();
    }

    await prefs.setStringList('cart', cart);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to cart!")),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        (screenWidth < 600) ? 2 : (screenWidth < 900 ? 3 : 4);
    double childAspectRatio =
        (screenWidth < 600) ? 0.65 : (screenWidth < 900 ? 0.7 : 0.6);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? _buildShimmerLoading()
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(product);
                },
              ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.80,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12.0),
                  ),
                  child: Container(
                    height: 140,
                    color: Colors.grey[300],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  child: Container(
                    height: 10,
                    color: Colors.grey[300],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  child: Container(
                    height: 10,
                    color: Colors.grey[300],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          height: 40,
                          child: Container(
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          width: 24,
                          height: 24,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: {
                "id": product["id"],
                "productName": product["name"],
                "price": product["price"],
                "imageUrl": product["image"],
                "description": product["description"],
                "benefits": product["benefits"],
              },
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              child: Image.network(
                product["image"]!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product["name"]!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${product["price"]!}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Color(0xFF00A86B),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: SizedBox(
                            height: 40,
                            child: CustomButton(
                              text: "BUY",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BuyNowScreen(),
                                    settings: RouteSettings(
                                      arguments: {
                                        'productName': product['productName'] ??
                                            'Unknown Product',
                                        'imageUrl': product['image'] ?? '',
                                        'price': product["price"] ?? ''
                                      },
                                    ),
                                  ),
                                );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const BuyNowScreen(),
                                //     settings: RouteSettings(
                                //       arguments: product,
                                //     ),
                                //   ),
                                // );
                              },
                              color: const Color(0xFF082580),
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              _addToCart(product);
                            },
                            icon: const Icon(
                              Icons.add_shopping_cart,
                              size: 22,
                              color: Color(0xFF082580),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
