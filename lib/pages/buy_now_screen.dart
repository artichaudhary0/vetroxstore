import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  bool _isLoading = true;
  String? _errorMessage;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      '✅ Order Confirmed!',
      "Thank You! Your Order is Successfully Placed.",
      platformChannelSpecifics,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final Map<String, dynamic>? fetchedProduct =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (fetchedProduct == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Product data is missing!";
        });
      } else {
        setState(() {
          product = fetchedProduct;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load product data. Please try again.";
      });
    }
  }

  void submitCheckout() async {
    if (_isChecked) {
      final address = {
        'village': _villageController.text,
        'district': _districtController.text,
        'pincode': _pincodeController.text,
        'landmark': _landmarkController.text,
        'state': _stateController.text,
        'mobile': _mobileController.text,
      };

      if (address.values.any((value) => value.isEmpty)) {
        _showDialog("Error", "Please fill in all address fields.");
        return;
      }

      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      _showDialog("Success", "Your order has been successfully placed.",
          navigate: true);
      Future.delayed(const Duration(seconds: 3), _showNotification);
    } else {
      _showDialog("Error", "Please agree to the Terms and Conditions.");
    }
  }

  void _showDialog(String title, String message, {bool navigate = false}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (navigate) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ThankYouPage()),
                );
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
      body: _errorMessage != null
          ? Center(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            product!['imageUrl'],
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
                              product!['productName'],
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
                        onChanged: null,
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
                      onPressed: submitCheckout,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
