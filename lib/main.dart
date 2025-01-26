import 'package:flutter/material.dart';
import 'package:vetroxstore/pages/main_screen.dart';
import 'package:vetroxstore/pages/signup_screen.dart';
import 'package:vetroxstore/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vetrox Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const SignupScreen(),
    );
  }
}
