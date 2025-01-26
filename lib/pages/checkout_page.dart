import 'package:flutter/material.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/custom/custom_textfield.dart';
import 'package:vetroxstore/pages/thank_you_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  bool _isChecked = false;

  final Map<String, dynamic> product = {
    'name': 'Sample Product',
    'price': 499,
    'image': 'https://via.placeholder.com/150', // Example image URL
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CHECKOUT",
          style: TextStyle(
            color: Colors.white,
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
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Your Address",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: "Enter village or locality...",
                controller: _villageController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: "Enter district or city...",
                controller: _districtController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: "Enter pincode...",
                keyboardType: TextInputType.number,
                controller: _pincodeController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: "Enter landmark...",
                controller: _landmarkController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: "Enter state...",
                controller: _stateController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: "Enter mobile number...",
                keyboardType: TextInputType.phone,
                controller: _mobileController,
              ),
              const SizedBox(height: 20),
              const Text(
                "Payment Option",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const ListTile(
                title: Text("Cash on Delivery"),
                leading: Radio(
                  value: true,
                  groupValue: true,
                  onChanged:
                      null, // Static for now as only one option is available
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "I agree to the Terms and Conditions.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "PLACE ORDER",
                color: const Color(0xFFad2806),
                onPressed: () {
                  if (_isChecked) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ThankYouPage(),
                      ),
                    );
                  } else {
                    // You can show an error message if the checkbox is not checked
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("Please agree to the terms and conditions")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
