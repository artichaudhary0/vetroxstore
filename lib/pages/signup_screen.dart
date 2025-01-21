import 'package:flutter/material.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/custom/custom_textfield.dart';
import 'package:vetroxstore/pages/login_screen.dart';
import 'package:vetroxstore/pages/main_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF082580),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "VETROX",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 30,
                          color: const Color(0xFF082580),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email label and text field
                    const CustomTextField(
                      label: 'Email',
                      hintText: 'Enter Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    // Password label and text field
                    const CustomTextField(
                      label: 'Password',
                      hintText: 'Enter Password...',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 15),
                    // Full Name label and text field

                    const CustomTextField(
                      label: 'Full Name',
                      hintText: 'Enter full name...',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'SIGN UP',
                      onPressed: () {
                        // Handle sign-up logic
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                        );
                      },
                      color: const Color(0xFFad2806),
                      width: MediaQuery.of(context).size.width,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Navigate to login screen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          "ALREADY HAVE AN ACCOUNT? LOG IN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
