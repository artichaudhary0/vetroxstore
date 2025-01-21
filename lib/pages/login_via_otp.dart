import 'package:flutter/material.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/custom/custom_textfield.dart';

class LoginOTPScreen extends StatelessWidget {
  const LoginOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    // Email label and text field
                    const CustomTextField(
                      label: 'Phone Number',
                      hintText: 'Enter phone number...',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 5),
                    Text(
                      "Please enter your phone number (in international format) that you would like to verify.",
                      style: TextStyle(
                        color: Colors.grey[80],
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          CustomButton(
                            text: 'GET OTP',
                            onPressed: () {
                              // Handle sign-up logic
                            },
                            width: MediaQuery.of(context).size.width * .5,
                          ),
                          const SizedBox(height: 15),
                          CustomButton(
                            text: 'LOG IN',
                            onPressed: () {
                              // Handle sign-up logic
                            },
                            width: MediaQuery.of(context).size.width * .5,
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
