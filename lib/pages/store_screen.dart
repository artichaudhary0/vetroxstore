import 'package:flutter/material.dart';
import 'package:vetroxstore/custom/custom_button.dart'; // Import your custom button

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {
        "name": "Product 1",
        "price": "₹ 200",
        "image": "https://via.placeholder.com/150"
      },
      {
        "name": "Product 2",
        "price": "₹ 200",
        "image": "https://via.placeholder.com/150"
      },
      {
        "name": "Product 3",
        "price": "₹ 200",
        "image": "https://via.placeholder.com/150"
      },
      {
        "name": "Product 4",
        "price": "₹ 200",
        "image": "https://via.placeholder.com/150"
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two items per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75, // Adjust height/width ratio of grid items
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
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
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
                      horizontal: 8.0, vertical: 4.0),
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
                      Expanded(
                        child: CustomButton(
                          text: "BUY",
                          fontSize: 14,
                          onPressed: () {
                            // Handle Add to Cart
                          },
                          color: const Color(0xFF082580),
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomButton(
                          text: "CART",
                          fontSize: 14,
                          onPressed: () {
                            // Handle Buy Now
                          },
                          color: const Color(0xFFad2806),
                          width: double.infinity,
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
    );
  }
}
