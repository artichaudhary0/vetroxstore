import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed; // Action when the button is pressed
  final Color color; // Button background color
  final double width; // Button width
  final double height; // Button height
  final bool isLoading; // Indicates loading state
  final Widget? child; // Custom content (Widget) for the button
  final String? text; // Text for the button, optional

  const CustomButton({
    super.key,
    required this.onPressed,
    this.color = const Color(0xFF082580),
    this.width = double.infinity,
    this.height = 45.0,
    this.isLoading = false,
    this.child,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Disable button when loading
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2.5,
                ),
              )
            : child ??
                Text(
                  text ?? '',
                  style: const TextStyle(
                    fontSize: 16,
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
