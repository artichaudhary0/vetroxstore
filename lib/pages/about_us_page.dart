import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ABOUT US",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.info_outline,
                color: Color(0xFF082580),
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Vetrox Veterinary Solution',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF082580),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Dr. Adarsh Tiwari, Managing Partner/Founder',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Mission Statement',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF082580),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Our mission is to provide high-quality veterinary solutions and exceptional care for pets.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact Info',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF082580),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Address: Vetrox Veterinary Solution, Prayagraj - 221508, Uttar Pradesh, India\n'
                'Email: contact@vetrox.in\nCall Us: +918384803668\nWhatsapp: +918384803668',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Text(
                'Why Choose Us?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF082580),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'We treat your pets as our own, ensuring they receive the best care possible.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'Thank you for trusting us with your pet’s care!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
