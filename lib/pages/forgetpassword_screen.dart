import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/custom/custom_textfield.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'reset_password_screen.dart'; // Import the ResetPasswordScreen

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  // Function to handle forgot password request
  Future<void> _forgotPassword() async {
    final email = _emailController.text;
    if (email.isEmpty) {
      setState(() {
        _message = 'Please enter your email.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://votexs.onrender.com/auth/forgot-password'), // Replace with actual backend URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final resetToken = data['resetToken'];

        // Save the reset token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('resetPasswordToken', resetToken);

        setState(() {
          _message = 'Please check your email for the reset link.';
        });

        // Navigate to the Reset Password Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(resetToken: resetToken),
          ),
        );
      } else {
        setState(() {
          _message = 'Failed to send reset link. Try again later.';
        });
      }
    } catch (error) {
      setState(() {
        _message = 'Error: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
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
                        "Enter your email address and we'll send you a link to reset your password.",
                        style: TextStyle(
                          color: Colors.grey[80],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Email label and text field
                      CustomTextField(
                        label: 'Email',
                        hintText: 'Enter email...',
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Column(
                          children: [
                            CustomButton(
                              text: _isLoading ? 'Sending...' : 'Submit',
                              onPressed: _forgotPassword,
                              color: const Color(0xFFad2806),
                              width: MediaQuery.of(context).size.width,
                            ),
                            const SizedBox(height: 15),
                            CustomButton(
                              text: 'Cancel',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.transparent,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_message.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _message.contains('error')
                                  ? Colors.red
                                  : Colors.green,
                              fontSize: 14,
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
      ),
    );
  }
}
