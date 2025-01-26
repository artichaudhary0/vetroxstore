import 'package:flutter/material.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/custom/custom_textfield.dart';
import 'package:vetroxstore/pages/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool isLoading = false;

  Future<void> _signup() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      _showErrorDialog("All fields are required.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final Map<String, String> payload = {
      'name': name,
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse('https://vertox.onrender.com/signup-email'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        final responseBody = json.decode(response.body);
        _showErrorDialog(responseBody['message'] ?? "Signup failed!");
      }
    } catch (error) {
      _showErrorDialog("An error occurred: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

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
                    CustomTextField(
                      label: 'Email',
                      hintText: 'Enter Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    // Password label and text field
                    CustomTextField(
                      label: 'Password',
                      hintText: 'Enter Password...',
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 15),
                    // Full Name label and text field
                    CustomTextField(
                      label: 'Full Name',
                      hintText: 'Enter full name...',
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      onPressed: _signup,
                      color: const Color(0xFFad2806),
                      width: MediaQuery.of(context).size.width,
                      isLoading: isLoading,
                      text: "SIGN UP",
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
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
