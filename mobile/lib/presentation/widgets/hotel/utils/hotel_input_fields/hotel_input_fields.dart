// hotel_input_fields.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/utils/hotel_input_fields/date_time_helper.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/utils/hotel_input_fields/input_field_helpers.dart';

class HotelInputFields extends StatefulWidget {
  final String hotelId;
  final String roomId;
  const HotelInputFields({
    super.key,
    required this.hotelId,
    required this.roomId,
  });

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
    userId = await secureStorage.read(key: 'userId');
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
          phoneNumberController.text.length >= 11 &&
          checkInDateController.text.isNotEmpty &&
          checkOutDateController.text.isNotEmpty &&
          adultsController.text.isNotEmpty &&
          childrenController.text.isNotEmpty;
    });
  }

  void _createBooking(BuildContext context) {
    DateTime? checkInDate = DateTime.tryParse(checkInDateController.text);
    DateTime? checkOutDate = DateTime.tryParse(checkOutDateController.text);
    DateTime? arrivalDateTime = combineDateAndTime(
        checkInDateController.text, timeOfArrivalController.text);
    DateTime? departureDateTime = combineDateAndTime(
        checkOutDateController.text, timeOfDepartureController.text);

    if (checkInDate != null &&
        checkOutDate != null &&
        arrivalDateTime != null &&
        departureDateTime != null &&
        userId != null) {
      final booking = BookingModel(
        id: '',
        bookingType: 'HotelBooking',
        hotelId: widget.hotelId,
        roomId: widget.roomId,
        fullName: fullNameController.text,
        email: emailController.text,
        phoneNumber: phoneNumberController.text,
        address: addressController.text,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        timeOfArrival: arrivalDateTime,
        timeOfDeparture: departureDateTime,
        adult: int.tryParse(adultsController.text) ?? 1,
        children: int.tryParse(childrenController.text) ?? 0,
        // totalPrice: 0.0,
        // isAccepted: false,
      );

// Print the BookingModel to the console
      print('BookingModel:');
      print('User ID: $userId');
      print('Booktype: ${booking.bookingType}');
      print('Hotel ID: ${booking.hotelId}');
      print('Room ID: ${booking.roomId}');
      print('Full Name: ${booking.fullName}');
      print('Email: ${booking.email}');
      print('Phone Number: ${booking.phoneNumber}');
      print('Address: ${booking.address}');
      print('Check-in Date: ${booking.checkInDate}');
      print('Check-out Date: ${booking.checkOutDate}');
      print('Time of Arrival: ${booking.timeOfArrival}');
      print('Time of Departure: ${booking.timeOfDeparture}');
      print('Adults: ${booking.adult}');
      print('Children: ${booking.children}');

      context.read<BookingBloc>().add(CreateBooking(
            booking: booking,
            userId: userId!,
          ));
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
                child: buildDatePickerField(checkInDateController,
                    'Check-in Date', context, 'Check-in date', () {
                  selectDate(context, checkInDateController);
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: buildDatePickerField(checkOutDateController,
                    'Check-out Date', context, 'Check-out date', () {
                  selectDate(context, checkOutDateController);
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: buildTimePickerField(
                    timeOfArrivalController, 'Time of Arrival', context, () {
                  selectTime(context, timeOfArrivalController);
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: buildTimePickerField(
                    timeOfDepartureController, 'Time of Departure', context,
                    () {
                  selectTime(context, timeOfDepartureController);
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: buildLabelledTextField(fullNameController, 'Full Name',
                    Icons.person, 'Juan Dela Cruz', _checkFieldsFilled),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: buildLabelledTextField(emailController, 'Email Address',
                    Icons.email, 'example@email.com', _checkFieldsFilled),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: buildLabelledTextField(
                    phoneNumberController,
                    'Phone Number',
                    Icons.phone,
                    '+63 9123456789',
                    _checkFieldsFilled),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: buildLabelledTextField(addressController, 'Address',
                    Icons.home, '123 Main St', _checkFieldsFilled),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: buildLabelledNumericTextField(adultsController,
                    'Adults (Pax)', Icons.people, '0', _checkFieldsFilled),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: buildLabelledNumericTextField(
                    childrenController,
                    'Children (Pax)',
                    Icons.child_care,
                    '0',
                    _checkFieldsFilled),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isBookButtonEnabled
                  ? () {
                      _createBooking(context);
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
}
