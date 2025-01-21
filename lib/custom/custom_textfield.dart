import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label; // Optional label
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText; // Error message
  final TextEditingController? controller; // Optional controller
  final String? Function(String?)? validator; // Optional validator

  const CustomTextField({
    super.key,
    this.label, // Made label optional
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.isNotEmpty) // Conditionally display label
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label!,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 16.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Color(0xFF082580), // Accent color
                width: 2.0,
              ),
            ),
            errorText: errorText, // Show error message when not null
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
