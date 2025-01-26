import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/custom/custom_textfield.dart';
import 'dart:convert';

import 'package:vetroxstore/pages/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String resetToken;
  const ResetPasswordScreen({super.key, required this.resetToken});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  String _message = '';

  // Function to handle reset password request
  Future<void> _resetPassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _message = 'Please enter both passwords.';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _message = 'Passwords do not match.';
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
            'https://votex-spca.onrender.com/reset-password'), // Replace with actual backend URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'resetToken': widget.resetToken,
          'newPassword': password,
        }),
      );

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _message = 'Password reset successfully!';
        });
        // Navigate to the Reset Password Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } else {
        setState(() {
          _message = 'Failed to reset password. Try again later.';
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
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Enter your new password.",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password text fields
                      CustomTextField(
                        label: 'New Password',
                        hintText: 'Enter new password...',
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: 'Confirm Password',
                        hintText: 'Confirm your new password...',
                        obscureText: true,
                        controller: _confirmPasswordController,
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Column(
                          children: [
                            CustomButton(
                              text: _isLoading
                                  ? 'Resetting...'
                                  : 'Reset Password',
                              onPressed: _resetPassword,
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
