import 'package:flutter/material.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/pages/checkout_page.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  final List<Map<String, dynamic>> _cartItems = [
    {
      "name": "Product 1",
      "price": 200,
      "quantity": 1,
      "image": "https://via.placeholder.com/150"
    },
    {
      "name": "Product 2",
      "price": 350,
      "quantity": 2,
      "image": "https://via.placeholder.com/150"
    },
    {
      "name": "Product 3",
      "price": 150,
      "quantity": 1,
      "image": "https://via.placeholder.com/150"
    },
  ];

  double get _totalPrice {
    return _cartItems.fold(
        0, (sum, item) => sum + item['price'] * item['quantity']);
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        _cartItems[index]['quantity'] = newQuantity;
      } else {
        _cartItems.removeAt(index);
      }
    });
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
              child: ListView.builder(
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
                                "₹${item['price']}",
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
                                    style: const TextStyle(fontSize: 16.0),
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
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _cartItems.removeAt(index);
                            });
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
