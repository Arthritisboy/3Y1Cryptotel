import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:intl/intl.dart';

class HotelInputFields extends StatefulWidget {
  const HotelInputFields({super.key});

  @override
  State<HotelInputFields> createState() => _HotelInputFieldsState();
}

class _HotelInputFieldsState extends State<HotelInputFields> {
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
  bool isBookButtonEnabled = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkFieldsFilled();
  }

  Future<void> _loadUserData() async {
    userId = await secureStorage.read(key: 'userId'); // Load the user ID
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

  void _checkFieldsFilled() {
    setState(() {
      isBookButtonEnabled = fullNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneNumberController.text.length >= 11;
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
      String formattedDate = picked.toIso8601String();
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

  DateTime? _combineDateAndTime(String date, String time) {
    if (date.isEmpty || time.isEmpty) return null;
    try {
      final parsedDate = DateTime.parse(date);
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
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking created successfully!')),
          );
        } else if (state is BookingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create booking: ${state.error}')),
          );
        }
      },
      child: Column(
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

          // Phone number and address fields...
          // Adults and children fields...

          const SizedBox(height: 20),

          // Book Now Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isBookButtonEnabled
                  ? () {
                      DateTime? checkInDate =
                          DateTime.tryParse(checkInDateController.text);
                      DateTime? checkOutDate =
                          DateTime.tryParse(checkOutDateController.text);
                      DateTime? arrivalDateTime = _combineDateAndTime(
                          checkInDateController.text,
                          timeOfArrivalController.text);
                      DateTime? departureDateTime = _combineDateAndTime(
                          checkOutDateController.text,
                          timeOfDepartureController.text);

                      if (checkInDate != null &&
                          checkOutDate != null &&
                          arrivalDateTime != null &&
                          departureDateTime != null &&
                          userId != null) {
                        final booking = BookingModel(
                          id: '', // ID will be generated by the backend
                          bookingType: 'HotelBooking',
                          hotelId:
                              'hotelIdHere', // Replace with actual hotel ID
                          roomId: 'roomIdHere', // Replace with actual room ID
                          fullName: fullNameController.text,
                          email: emailController.text,
                          phoneNumber: phoneNumberController.text,
                          address: addressController.text,
                          checkInDate: checkInDate,
                          checkOutDate: checkOutDate,
                          timeOfArrival: arrivalDateTime,
                          timeOfDeparture: departureDateTime,
                          adults: int.tryParse(adultsController.text) ?? 1,
                          children: int.tryParse(childrenController.text) ?? 0,
                          totalPrice:
                              0.0, // Total price will be calculated on the backend
                          isAccepted: false,
                        );

                        // Dispatch CreateBooking event
                        context.read<BookingBloc>().add(CreateBooking(
                              booking: booking,
                              userId: userId!,
                            ));
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isBookButtonEnabled
                    ? const Color.fromARGB(255, 29, 53, 115)
                    : Colors.grey,
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
      ),
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
              _checkFieldsFilled();
            },
          ),
        ),
      ],
    );
  }
}
