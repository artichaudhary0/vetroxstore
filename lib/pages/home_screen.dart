import 'package:flutter/material.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/pages/login_screen.dart';
import 'package:vetroxstore/pages/login_via_otp.dart';
import 'package:vetroxstore/pages/signup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Welcome !",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF082580),
                ),
              ),
              Image.asset(
                'assets/applogo.png',
                width: 250,
                height: 250,
              ),
              CustomButton(
                text: 'SIGN UP',
                onPressed: () {
                  // Handle login logic
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
                width: MediaQuery.of(context).size.width * 1,
              ),
              const SizedBox(height: 25),
              const Text(
                "Already have an account?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              CustomButton(
                text: 'LOG IN',
                onPressed: () {
                  // Handle registration logic
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              const SizedBox(height: 60),
              CustomButton(
                text: 'LOGIN VIA OTP',
                onPressed: () {
                  // Handle contact logic
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginOTPScreen()),
                  );
                },
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
