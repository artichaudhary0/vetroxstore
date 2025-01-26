import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetroxstore/custom/custom_button.dart'; // Import your custom button
import 'package:http/http.dart' as http;
import 'package:vetroxstore/pages/buy_now_screen.dart';
import 'dart:convert';

import 'checkout_page.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<Map<String, dynamic>> products = []; // Change to dynamic type
  String token = '';

  @override
  void initState() {
    super.initState();
    _getToken();
    _fetchProducts();
  }

  // Retrieve the token from SharedPreferences
  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ??
        ''; // Retrieve token from shared preferences
  }

  // Fetch products from an API or local data
  // Future<void> _fetchProducts() async {
  //   // For example, if fetching products from a server, it can look like this:
  //   // Replace with actual API URL
  //   final prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString('token') ?? '';
  //   print("tokeennnnn" + token);
  //   const url = 'https://vertox.onrender.com/products';
  //   final response = await http.get(Uri.parse(url), headers: {
  //     'Authorization': 'Bearer $token', // Pass the token in the request headers
  //   });
  //
  //   print(response.statusCode);
  //   print(response.body);
  //
  //   if (response.statusCode == 200) {
  //     // Parse the response and update the state
  //     final List<dynamic> data = json.decode(response.body);
  //     setState(() {
  //       products = data
  //           .map((product) => {
  //                 "name": product["name"],
  //                 "price": product["price"].toString(),
  //                 "image": product["image"]
  //               })
  //           .toList();
  //     });
  //   } else {
  //     // Handle error
  //     print('Failed to fetch products');
  //   }
  // }

  Future<void> _fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    print("tokeennnnn" + token);

    const url = 'https://vertox.onrender.com/products';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token', // Pass the token in the request headers
    });

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
                })
            .toList();
      });
    } else {}
  }

  _buyNow(Map<String, dynamic> product) async {}

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
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        (screenWidth < 600) ? 2 : (screenWidth < 900 ? 3 : 4);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: products.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.65,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Container(
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
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.0),
                          child: Text(
                            product["name"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.0),
                          child: Text(
                            product["price"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
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
                                  child: CustomButton(
                                    text: "BUY",
                                    fontSize: 12,
                                    onPressed: () {
                                      // Pass the product data to CheckoutScreen via arguments
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const BuyNowScreen(),
                                          settings: RouteSettings(
                                            arguments:
                                                product, // Pass the selected product
                                          ),
                                        ),
                                      );
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
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
