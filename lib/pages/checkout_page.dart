import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  bool _isLoading = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
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

  void _showDialog(String title, String content, {bool navigate = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoading = false;
                  _villageController.clear();
                  _districtController.clear();
                  _pincodeController.clear();
                  _landmarkController.clear();
                  _stateController.clear();
                  _mobileController.clear();
                });
                if (navigate) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThankYouPage(),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _placeOrder() async {
    // Check if all fields are filled
    if (_villageController.text.isEmpty ||
        _districtController.text.isEmpty ||
        _pincodeController.text.isEmpty ||
        _landmarkController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _mobileController.text.isEmpty) {
      _showDialog("Error", "Please fill in all the fields.");
      return;
    }
    if (!_isChecked) {
      _showDialog("Error", "Please agree to the terms and conditions.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    _showDialog("Success", "Your order has been successfully placed.",
        navigate: true);
    Future.delayed(const Duration(seconds: 3), _showNotification);
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
                onPressed: _placeOrder,
                color: const Color(0xFFad2806),
                width: MediaQuery.of(context).size.width,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
