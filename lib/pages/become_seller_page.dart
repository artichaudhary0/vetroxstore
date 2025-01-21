import 'package:flutter/material.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/custom/custom_textfield.dart';

class BecomeSellerPage extends StatelessWidget {
  const BecomeSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BECOME A SELLER",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 8.0,
        backgroundColor: const Color(0xFF082580),
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Join Our Platform as a Seller",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF082580),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Fill out the form below to apply as a seller and start selling on our platform.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                label: "Name",
                hintText: "Enter name...",
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Mobile",
                hintText: "Enter mobile...",
              ),
              const SizedBox(height: 60),
              CustomButton(
                  text: "Submit",
                  color: const Color(0xFFad2806),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Application Submitted"),
                          content: const Text(
                              "Your application to become a seller has been submitted!"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
