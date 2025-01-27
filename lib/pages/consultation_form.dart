import 'package:flutter/material.dart';
import 'package:vetroxstore/custom/custom_button.dart';
import 'package:vetroxstore/custom/custom_textfield.dart'; // Your Custom TextField
import 'package:intl/intl.dart'; // Import for date formatting

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

  // Date picker function
  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime now = DateTime.now();

    // Show date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now, // Restrict past dates
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Show time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (pickedTime != null) {
        // Combine date and time
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Check if the combined date and time is in the past
        if (combinedDateTime.isBefore(now)) {
          // Show error dialog if the date and time are invalid
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

        // Format the combined DateTime into the desired format
        setState(() {
          _dateController.text = DateFormat('EEE, MMM d, yyyy h:mm a')
              .format(combinedDateTime); // Example: "Wed, Jan 1, 2025 5:30 PM"
        });
      }
    }
  }

  Future<void> _submitForm() async {
    // Validate the form
    if (_formKey.currentState?.validate() ?? false) {
      // Show a loading indicator and proceed with form submission
      setState(() {
        _isLoading = true;
      });

      // Simulate a delay for the booking process (e.g., API call)
      await Future.delayed(const Duration(seconds: 2));

      // Show a success popup
      showDialog(
        context: context,
        barrierDismissible:
            false, // Prevent dialog from being dismissed by tapping outside
        builder: (context) {
          return AlertDialog(
            title: const Text("Success"),
            content:
                const Text("Your appointment has been successfully booked."),
            actions: [
              TextButton(
                onPressed: () {
                  // Reset the form fields and hide the loading indicator
                  setState(() {
                    _isLoading = false;
                    _nameController.clear();
                    _mobileController.clear();
                    _dateController.clear();
                    _consultationType = null;
                  });

                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // If validation fails, focus the first invalid field (optional)
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Disable the "Create Booking" button if the date is in the past
    final isBookingDisabled = _dateController.text.isEmpty ||
        DateFormat('EEE, MMM d, yyyy h:mm a')
            .parse(_dateController.text, true)
            .isBefore(DateTime.now());

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
