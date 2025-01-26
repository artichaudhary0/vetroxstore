import 'package:flutter/material.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/pages/main_screen.dart'; // Assuming you have a custom button widget

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "THANK YOU",
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
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 8.0,
        backgroundColor: const Color(0xFF082580),
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Thank You for Your Order!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Your order has been successfully placed and will be delivered soon.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // const Text(
            //   'Order Summary',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.w600,
            //     color: Colors.black,
            //   ),
            // ),
            // const SizedBox(height: 10),
            // const Card(
            //   margin: EdgeInsets.symmetric(vertical: 10.0),
            //   child: Padding(
            //     padding: EdgeInsets.all(16.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text('Product: Widget Pro'),
            //         SizedBox(height: 5),
            //         Text('Price: ₹200'),
            //         SizedBox(height: 5),
            //         Text('Quantity: 1'),
            //         SizedBox(height: 5),
            //         Text('Total: ₹200'),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 30),
            CustomButton(
              text: "Go to Home",
              color: const Color(0xFF082580),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                ); // Navigate to Home Page
              },
            ),
          ],
        ),
      ),
    );
  }
}
