import 'package:flutter/material.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/custom/custom_textfield.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Password Reset",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Enter your email address and (in international format) that you would like to verify.",
                      style: TextStyle(
                        color: Colors.grey[80],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email label and text field
                    const CustomTextField(
                      label: 'Email',
                      hintText: 'Enter email...',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          CustomButton(
                            text: 'Submit',
                            onPressed: () {
                              // Handle sign-up logic
                            },
                            color: const Color(0xFFad2806),
                            width: MediaQuery.of(context).size.width,
                          ),
                          const SizedBox(height: 15),
                          CustomButton(
                            text: 'Cancel',
                            onPressed: () {
                              // Handle sign-up logic
                            },
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
