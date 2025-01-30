import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/pages/buy_now_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // void _addToCart() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<String> cart = prefs.getStringList('cart') ?? [];
  //
  //   bool isProductInCart = cart.any((item) {
  //     Map<String, dynamic> cartItem = json.decode(item);
  //     return cartItem['Name'] == widget.product['Name'];
  //   });
  //
  //   if (!isProductInCart) {
  //     widget.product['quantity'] = 1;
  //     cart.add(json.encode(widget.product));
  //   } else {
  //     cart = cart.map((item) {
  //       Map<String, dynamic> cartItem = json.decode(item);
  //       if (cartItem['Name'] == widget.product['Name']) {
  //         cartItem['quantity'] = (cartItem['quantity'] ?? 0) + 1;
  //       }
  //       return json.encode(cartItem);
  //     }).toList();
  //   }
  //
  //   await prefs.setStringList('cart', cart);
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Added to cart!")),
  //   );
  // }

  void _addToCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];

    bool isProductInCart = cart.any((item) {
      Map<String, dynamic> cartItem = json.decode(item);
      return cartItem['id'] == widget.product['id']; // Uses 'id' for matching
    });

    if (!isProductInCart) {
      widget.product['quantity'] = 1; // Set initial quantity
      cart.add(json.encode(widget.product));
    } else {
      cart = cart.map((item) {
        Map<String, dynamic> cartItem = json.decode(item);
        if (cartItem['id'] == widget.product['id']) {
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

  @override
  Widget build(BuildContext context) {
    // Get the screen width for responsive design
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust text and padding based on screen size
    double productTitleFontSize = screenWidth < 600 ? 20 : 22;
    double descriptionFontSize = screenWidth < 600 ? 14 : 16;
    double benefitFontSize = screenWidth < 600 ? 14 : 16;
    double imageHeight = screenWidth < 600 ? 180 : 200;
    double buttonFontSize = screenWidth < 600 ? 14 : 16;

    String productName = widget.product['productName'] ?? 'Unknown Product';
    String description =
        widget.product['description'] ?? 'No description available';
    List<String> benefits = List<String>.from(widget.product['benefits'] ?? []);
    String imageUrl = widget.product['imageUrl'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(productName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.network(imageUrl,
                  height: imageHeight, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Text(
              productName,
              style: TextStyle(
                  fontSize: productTitleFontSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: descriptionFontSize),
            ),
            const SizedBox(height: 12),
            const Text(
              "Benefits:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: benefits.map((benefit) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.green, size: 12),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(fontSize: benefitFontSize),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Spacer(), // This widget will push the content up and the buttons to the bottom
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 16.0), // Padding to provide space from the bottom
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Buy Now",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuyNowScreen(),
                            settings: RouteSettings(
                              arguments: {
                                'productName': widget.product['productName'] ??
                                    'Unknown Product',
                                'description': widget.product['description'] ??
                                    'No description available',
                                'imageUrl': widget.product['imageUrl'] ?? '',
                                'price': widget.product["price"] ?? ''
                              },
                            ),
                          ),
                        );
                      },
                      color: Color(0xFF082580),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Expanded(
                  //   child: CustomButton(
                  //     text: "Add to Cart",
                  //     onPressed: _addToCart,
                  //     color: Colors.orange,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
