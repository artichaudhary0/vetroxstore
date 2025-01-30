import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/custom/custom_textfield.dart';
import 'package:vetroxstore/pages/main_screen.dart';

class LoginOTPScreen extends StatefulWidget {
  const LoginOTPScreen({super.key});

  @override
  State<LoginOTPScreen> createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String verificationId = '';
  bool isOtpSent = false;
  bool isLoading = false;

  Future<void> sendOtp() async {
    setState(() => isLoading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91" + phoneController.text.trim(),
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException ex) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${ex.message}')),
        );
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          isOtpSent = true;
          verificationId = verId;
          isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verId) {
        setState(() => verificationId = verId);
      },
    );
  }

  Future<void> verifyOtp() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text.trim(),
      );
      await _signInWithCredential(credential);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP: $e')),
      );
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    String? token = await userCredential.user?.getIdToken();
    print(token);

    if (token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      _navigateToMainScreen();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to retrieve token')),
      );
    }
  }

  void _navigateToMainScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
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
            children: [
              const SizedBox(height: 40),
              CustomTextField(
                controller: phoneController,
                label: 'Phone Number',
                hintText: 'Enter phone number...',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              const Text(
                  "Please enter the phone number (in international format) that you would like to verify."),
              const SizedBox(height: 10),
              if (!isOtpSent)
                CustomButton(
                  text: isLoading ? 'SENDING...' : 'GET OTP',
                  onPressed: sendOtp,
                  width: MediaQuery.of(context).size.width * .5,
                ),
              if (isOtpSent) ...[
                const SizedBox(height: 10),
                CustomTextField(
                  controller: otpController,
                  label: 'Enter OTP',
                  hintText: 'Enter OTP...',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                CustomButton(
                  text: 'VERIFY OTP',
                  onPressed: verifyOtp,
                  color: const Color(0xFFad2806),
                  width: MediaQuery.of(context).size.width,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : null,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
