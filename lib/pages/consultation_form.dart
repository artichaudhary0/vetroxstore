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

  // Date picker function
  Future<void> _selectDateAndTime(BuildContext context) async {
    // Show date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Show time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (pickedTime != null) {
        // Combine date and time and format it
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Format the combined DateTime into the desired format (short day name)
        setState(() {
          _dateController.text = DateFormat('EEE, MMM d, yyyy h:mm a')
              .format(combinedDateTime); // Example: "Wed, Jan 1, 2025 5:30 PM"
        });
      }
    }
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
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: "Name",
                hintText: "Enter name...",
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Mobile Number",
                hintText: "Enter mobile...",
                controller: _mobileController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 50),
              CustomButton(
                text: "CREATE BOOKING",
                color: const Color(0xFFad2806),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Handle form submission
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
