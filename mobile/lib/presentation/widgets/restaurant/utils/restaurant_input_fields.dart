import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'shared_widgets.dart'; // Shared UI components for input fields
import 'date_time_helper.dart'; // Helper for selecting date, time, and combining
import 'package:hotel_flutter/presentation/widgets/utils_widget/custom_dialog.dart'; // Import the CustomDialog widget

class RestaurantInputFields extends StatefulWidget {
  final String restaurantId;
  final int capacity;

  const RestaurantInputFields({
    super.key,
    required this.restaurantId,
    required this.capacity,
  });

  @override
  State<RestaurantInputFields> createState() => _RestaurantInputFieldsState();
}

class _RestaurantInputFieldsState extends State<RestaurantInputFields> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController =
      TextEditingController(text: "+63 ");
  final TextEditingController addressController = TextEditingController();
  final TextEditingController checkInDateController = TextEditingController();
  final TextEditingController checkOutDateController =
      TextEditingController(); // Added checkOutDateController
  final TextEditingController timeOfArrivalController = TextEditingController();
  final TextEditingController timeOfDepartureController =
      TextEditingController();
  final TextEditingController adultsController = TextEditingController();
  final TextEditingController childrenController = TextEditingController();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool isBookButtonEnabled = false;
  String? userId;
  bool isLoading = false; // For button loading state

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
          checkOutDateController
              .text.isNotEmpty && // Check for checkOutDateController
          timeOfArrivalController.text.isNotEmpty &&
          timeOfDepartureController.text.isNotEmpty &&
          adultsController.text.isNotEmpty &&
          childrenController.text.isNotEmpty;
    });
  }

  // Dialog to show when the guest capacity is exceeded
  void _showCapacityErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Guest Limit Exceeded',
          description:
              'You have exceeded the maximum guest capacity for this restaurant. Please reduce the number of guests to proceed.',
          buttonText: 'Close',
          onButtonPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          onSecondButtonPressed: () {},
        );
      },
    );
  }

  // Dialog to show when booking is successful
  void _showBookingSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Booking Successful',
          description:
              'Your booking has been successfully submitted and is currently being processed. You will be notified once it is confirmed.',
          buttonText: 'OK',
          onButtonPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/homescreen');
          },
          onSecondButtonPressed: () {},
        );
      },
    );
  }

  void _createBooking(BuildContext context) {
    // Close the keyboard to prevent interference with dialogs
    FocusScope.of(context).unfocus();

    // Parse dates and times from the input controllers
    DateTime? checkInDate = _parseDate(checkInDateController.text);
    DateTime? checkOutDate = _parseDate(checkOutDateController.text);
    DateTime now = DateTime.now();

    // Combine the arrival and departure times with their corresponding dates
    DateTime? arrivalDateTime = combineDateAndTime(
      checkInDateController.text,
      timeOfArrivalController.text,
    );
    DateTime? departureDateTime = combineDateAndTime(
      checkOutDateController.text,
      timeOfDepartureController.text,
    );

    // Ensure at least one adult is present
    int adults = int.tryParse(adultsController.text) ?? 0;
    int children = int.tryParse(childrenController.text) ?? 0;

    if (adults == 0 && children == 0) {
      _showErrorDialog(context,
          'Please provide the number of guests to proceed with booking.');
      return;
    }

    if (adults == 0) {
      _showErrorDialog(
          context, 'At least one adult is required to make a booking.');
      return;
    }

    // Validate arrival and departure times
    if (arrivalDateTime != null && departureDateTime != null) {
      if (departureDateTime.isBefore(arrivalDateTime)) {
        _showErrorDialog(
            context, 'Departure time cannot be before the arrival time.');
        return;
      }

      // Same-day booking with 12-hour difference validation
      if (arrivalDateTime.day == departureDateTime.day) {
        Duration timeDifference = departureDateTime.difference(arrivalDateTime);
        if (timeDifference.inHours < 12) {
          _showErrorDialog(
            context,
            'For same-day bookings, the departure time must be at least 12 hours after the arrival time.',
          );
          return;
        }
      }
    }

    // Ensure the arrival date and time is not in the past
    if (arrivalDateTime != null && arrivalDateTime.isBefore(now)) {
      _showErrorDialog(context, 'The arrival time cannot be in the past.');
      return;
    }

    // Validate total guests against the restaurant capacity
    final int totalGuests = adults + children;
    if (totalGuests > widget.capacity) {
      _showCapacityErrorDialog(context); // Show capacity error
      return;
    }

    // Proceed with booking if all validations pass
    if (checkInDate != null &&
        checkOutDate != null &&
        arrivalDateTime != null &&
        departureDateTime != null &&
        userId != null) {
      final booking = BookingModel(
        bookingType: 'RestaurantBooking',
        restaurantId: widget.restaurantId,
        fullName: fullNameController.text,
        email: emailController.text,
        phoneNumber: phoneNumberController.text,
        address: addressController.text,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        timeOfArrival: arrivalDateTime,
        timeOfDeparture: departureDateTime,
        adult: adults,
        children: children,
        tableNumber: totalGuests, // Sum of adults and children
      );

      setState(() {
        isLoading = true; // Show loading spinner
      });

      context.read<BookingBloc>().add(CreateBooking(
            booking: booking,
            userId: userId!,
          ));
    }
  }

  DateTime? _parseDate(String date) {
    try {
      return DateTime.parse(date);
    } catch (e) {
      return null;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Booking Invalid',
          description: message,
          buttonText: 'OK',
          onButtonPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          onSecondButtonPressed: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingCreateSuccess) {
          setState(() {
            isLoading = false; // Hide loading spinner
          });
          _showBookingSuccessDialog(context);
        } else if (state is BookingFailure) {
          setState(() {
            isLoading = false; // Hide loading spinner
          });
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
              onPressed: isBookButtonEnabled && !isLoading
                  ? () {
                      _createBooking(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isBookButtonEnabled && !isLoading
                    ? const Color.fromARGB(255, 29, 53, 115)
                    : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
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
