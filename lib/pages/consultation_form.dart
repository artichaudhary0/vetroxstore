import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/custom/custom_textfield.dart';
import 'package:intl/intl.dart';

class ConsultationForm extends StatefulWidget {
  const ConsultationForm({super.key});

  @override
  State<ConsultationForm> createState() => _ConsultationFormState();
}

class _ConsultationFormState extends State<ConsultationForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _consultationType;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> _consultationTypes = [
    "Dairy",
    "Fishery",
    "Goat",
    "Pet Animal and Birds",
    "Pig",
    "Poultry"
  ];

  bool _isLoading = false;

  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (combinedDateTime.isBefore(now)) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Invalid Date and Time"),
                content: const Text(
                    "The selected date and time cannot be in the past."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
          return;
        }

        setState(() {
          _dateController.text =
              DateFormat('EEE, MMM d, yyyy h:mm a').format(combinedDateTime);
        });
      }
    }
  }

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
      '✅ Consultation Appointment Booked!',
      "Your consultation appointment has been successfully booked.",
      platformChannelSpecifics,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      _showNotification();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Success"),
            content:
                const Text("Your appointment has been successfully booked."),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoading = false;
                    _nameController.clear();
                    _mobileController.clear();
                    _dateController.clear();
                    _consultationType = null;
                  });

                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 50),
              DropdownButtonFormField<String>(
                value: _consultationType,
                items: _consultationTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _consultationType = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Consultation Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                validator: (value) {
                  if (value == null) {
                    return "Please select a consultation type";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Booking Date & Time",
                    hintText: "Select a date and time",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDateAndTime(context),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a date and time";
                    }
                    try {
                      final DateTime selectedDate =
                          DateFormat('EEE, MMM d, yyyy h:mm a')
                              .parse(value, true); // Parse the input
                      if (selectedDate.isBefore(DateTime.now())) {
                        return "Selected date and time cannot be in the past";
                      }
                    } catch (e) {
                      return "Invalid date and time format";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: "Name",
                hintText: "Enter name...",
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name cannot be empty";
                  } else if (value.trim().length < 2) {
                    return "Name must be at least 2 characters long";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Mobile Number",
                hintText: "Enter mobile...",
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Mobile number is required";
                  } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return "Mobile number must be 10 digits";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              CustomButton(
                text: "CREATE BOOKING",
                onPressed: _submitForm,
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
