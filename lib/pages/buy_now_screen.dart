import 'package:flutter/material.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/custom/custom_textfield.dart';
import 'package:vetroxstore/pages/thank_you_screen.dart';

class BuyNowScreen extends StatefulWidget {
  const BuyNowScreen({super.key});

  @override
  State<BuyNowScreen> createState() => _BuyNowScreenState();
}

class _BuyNowScreenState extends State<BuyNowScreen> {
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  bool _isChecked = false;
  Map<String, dynamic>? product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  }

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
      body: product == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show product image, name, and price
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            product!['image'],
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Your Order",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              product!['name'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "₹${double.tryParse(product!['price'].toString())?.toStringAsFixed(2) ?? product!['price']}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

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
