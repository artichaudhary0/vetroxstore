import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/custom/custom_textfield.dart';
import 'package:http/http.dart' as http;

class LoginOTPScreen extends StatefulWidget {
  const LoginOTPScreen({super.key});

  @override
  State<LoginOTPScreen> createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String phone = '';
  String otp = '';
  bool isOtpSent = false;

  // Function to send OTP to the phone number
  Future<void> sendOtp() async {
    final response = await http.post(
      Uri.parse('https://vertox.onrender.com/signup-phone'),
      body: json.encode({'mobile': phone}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        isOtpSent = true;
      });
    } else {
      print('Failed to send OTP');
    }
  }

  Future<void> verifyOtp() async {
    final response = await http.post(
      Uri.parse('https://your-backend-url.com/verify-mobile'),
      body: json.encode({'mobile': phone, 'otp': otp}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final token = responseBody['token'];

      // Save the token in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      print('OTP verified successfully, token saved!');
      // Navigate to the next screen or login
    } else {
      print('Invalid OTP');
    }
  }

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
