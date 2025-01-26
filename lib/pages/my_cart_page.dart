import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/pages/checkout_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  // Load cart items from SharedPreferences
  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];

    setState(() {
      _cartItems = cart.map((item) {
        var parsedItem = json.decode(item) as Map<String, dynamic>;
        // Ensure 'price' is parsed as a double
        parsedItem['price'] =
            double.tryParse(parsedItem['price'].toString()) ?? 0.0;
        parsedItem['quantity'] =
            parsedItem['quantity'] ?? 1; // Default quantity to 1
        return parsedItem;
      }).toList();
    });
  }

  // Calculate the total price of items in the cart
  double get _totalPrice {
    return _cartItems.fold(
        0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  // Update quantity of cart item
  void _updateQuantity(int index, int newQuantity) async {
    setState(() {
      if (newQuantity > 0) {
        _cartItems[index]['quantity'] = newQuantity;
      } else {
        _cartItems.removeAt(index);
      }
    });

    // Save updated cart back to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'cart',
        _cartItems.map((item) {
          // Ensure 'price' is stored as a double
          item['price'] = double.tryParse(item['price'].toString()) ?? 0.0;
          return json.encode(item);
        }).toList());
  }

  // Remove item from cart
  void _removeItem(int index) async {
    setState(() {
      _cartItems.removeAt(index);
    });

    // Save updated cart back to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'cart',
        _cartItems.map((item) {
          // Ensure 'price' is stored as a double
          item['price'] = double.tryParse(item['price'].toString()) ?? 0.0;
          return json.encode(item);
        }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MY CART",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 8.0, // Controls the shadow depth
        backgroundColor: const Color(0xFF082580), // AppBar color
        shadowColor: Colors.black.withOpacity(0.5), // Shadow color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _cartItems.isEmpty
                  ? const Center(child: Text('No items in cart'))
                  : ListView.builder(
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  item['image'],
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "₹${item['price'].toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            _updateQuantity(
                                                index, item['quantity'] - 1);
                                          },
                                        ),
                                        Text(
                                          item['quantity'].toString(),
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            _updateQuantity(
                                                index, item['quantity'] + 1);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _removeItem(index);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Price:",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "₹${_totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            CustomButton(
              text: "CHECKOUT",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
