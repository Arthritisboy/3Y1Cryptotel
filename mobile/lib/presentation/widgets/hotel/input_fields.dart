import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // Import for input formatters

class InputFields extends StatefulWidget {
  const InputFields({super.key});

  @override
  _InputFieldsState createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController =
      TextEditingController(text: "+63 ");
  final TextEditingController addressController = TextEditingController();
  final TextEditingController checkInDateController = TextEditingController();
  final TextEditingController checkOutDateController = TextEditingController();
  final TextEditingController adultsController = TextEditingController();
  final TextEditingController childrenController = TextEditingController();

  // Add TextEditingControllers for time of arrival and departure
  final TextEditingController timeOfArrivalController = TextEditingController();
  final TextEditingController timeOfDepartureController =
      TextEditingController();

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  // Add function to select time
  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      String formattedTime = picked.format(context);
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildDatePickerField(checkInDateController,
                  'Check-in Date', context, 'Check-in date'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDatePickerField(checkOutDateController,
                  'Check-out Date', context, 'Check-out date'),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Time of Arrival and Departure Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildTimePickerField(
                timeOfArrivalController,
                'Time of Arrival',
                context,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTimePickerField(
                timeOfDepartureController,
                'Time of Departure',
                context,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildLabelledTextField(fullNameController, 'Full Name',
                  Icons.person, 'Juan Dela Cruz'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildLabelledTextField(emailController, 'Email Address',
                  Icons.email, 'example@email.com'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildPhoneNumberField(
                  phoneNumberController, 'Phone Number', Icons.phone),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildLabelledTextField(
                  addressController, 'Address', Icons.home, '123 Main St'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildLabelledNumericTextField(
                  adultsController, 'Adults (Pax)', Icons.people, '0'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildLabelledNumericTextField(
                  childrenController, 'Children (Pax)', Icons.child_care, '0'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Book Now Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              print("Book Now button pressed");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 29, 53, 115),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Book Now',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField(
      TextEditingController controller, String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 142, 142, 147),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(12),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
              prefixIcon: Icon(icon),
              hintText: '+63 9123456789',
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (value) {
              if (value.length > 3 && value.substring(0, 3) == "+63") {
                if (value.length > 15) {
                  controller.text = value.substring(0, 15);
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length),
                  );
                }
              }
            },
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelledTextField(TextEditingController controller, String label,
      IconData icon, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 142, 142, 147),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 40, // Adjust height here
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
              prefixIcon: Icon(icon),
              hintText: placeholder,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelledNumericTextField(TextEditingController controller,
      String label, IconData icon, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 142, 142, 147),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
              prefixIcon: Icon(icon),
              hintText: placeholder,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String label,
      BuildContext context, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 142, 142, 147),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
              prefixIcon: Icon(Icons.calendar_today),
              hintText: placeholder,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onTap: () {
              _selectDate(context, controller);
            },
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerField(
      TextEditingController controller, String label, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 142, 142, 147),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
              prefixIcon: Icon(Icons.access_time),
              hintText: 'Select Time',
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onTap: () {
              _selectTime(context, controller);
            },
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
