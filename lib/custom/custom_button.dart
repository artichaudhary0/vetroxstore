import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double width;
  final double? fontSize; // Optional fontSize parameter

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFF082580),
    this.width = double.infinity,
    this.fontSize, // Optional fontSize
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize:
                fontSize ?? 16, // Use default fontSize of 16 if not provided
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
        ),
      ),
    );
  }
}
