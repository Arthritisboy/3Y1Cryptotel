import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // For secure storage

class RestaurantInputFields extends StatefulWidget {
  const RestaurantInputFields({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RestaurantInputFieldsState();
  }
}

class _RestaurantInputFieldsState extends State<RestaurantInputFields> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController =
      TextEditingController(text: "+63 ");
  final TextEditingController addressController = TextEditingController();
  final TextEditingController checkInDateController = TextEditingController();
  final TextEditingController checkOutDateController = TextEditingController();
  final TextEditingController adultsController = TextEditingController();
  final TextEditingController childrenController = TextEditingController();

  final TextEditingController timeOfArrivalController = TextEditingController();
  final TextEditingController timeOfDepartureController =
      TextEditingController();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  bool isBookButtonEnabled = false; // To control the Book Now button

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkFieldsFilled();
  }

  // Load user data from FlutterSecureStorage
  Future<void> _loadUserData() async {
    String? firstName = await secureStorage.read(key: 'firstName') ?? '';
    String? lastName = await secureStorage.read(key: 'lastName') ?? '';
    String? storedEmail = await secureStorage.read(key: 'email') ?? '';
    String? storedPhoneNumber =
        await secureStorage.read(key: 'phoneNumber') ?? '+63 ';

    setState(() {
      fullNameController.text = '$firstName $lastName'.trim();
      emailController.text = storedEmail;
      phoneNumberController.text = storedPhoneNumber;
    });

    _checkFieldsFilled();
  }

  // Check if all required fields are filled
  void _checkFieldsFilled() {
    setState(() {
      isBookButtonEnabled = fullNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneNumberController.text.length >= 11; // Example condition
    });
  }

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
        _checkFieldsFilled();
      });
    }
  }

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
        _checkFieldsFilled();
      });
    }
  }

  // This function combines the date and time fields into a single DateTime object.
  DateTime? _combineDateAndTime(String date, String time) {
    if (date.isEmpty || time.isEmpty) return null;
    try {
      final parsedDate = DateTime.parse(date); // Parse the date
      final parsedTime = TimeOfDay.fromDateTime(
          DateFormat.jm().parse(time)); // Parse the time (e.g., "9:30 AM")

      return DateTime(parsedDate.year, parsedDate.month, parsedDate.day,
          parsedTime.hour, parsedTime.minute);
    } catch (e) {
      print("Error parsing date or time: $e");
      return null;
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
            onPressed: isBookButtonEnabled
                ? () {
                    DateTime? arrivalDateTime = _combineDateAndTime(
                        checkInDateController.text,
                        timeOfArrivalController.text);
                    DateTime? departureDateTime = _combineDateAndTime(
                        checkOutDateController.text,
                        timeOfDepartureController.text);

                    print("Time of Arrival: $arrivalDateTime");
                    print("Time of Departure: $departureDateTime");

                    // Send these DateTime objects to the backend
                  }
                : null, // Disable button when fields are incomplete
            style: ElevatedButton.styleFrom(
              backgroundColor: isBookButtonEnabled
                  ? const Color.fromARGB(255, 29, 53, 115)
                  : Colors.grey, // Change color if disabled
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
              _checkFieldsFilled(); // Check if fields are filled when input changes
            },
            style: const TextStyle(
                color: Colors.black), // Make text black when present
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
          height: 40,
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
            onChanged: (value) {
              _checkFieldsFilled(); // Check if fields are filled when input changes
            },
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
            onChanged: (value) {
              _checkFieldsFilled(); // Check if fields are filled when input changes
            },
          ),
        ),
      ],
    );
  }
}
