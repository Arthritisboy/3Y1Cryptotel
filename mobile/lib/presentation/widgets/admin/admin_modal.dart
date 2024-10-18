import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:intl/intl.dart';

class AdminModal extends StatefulWidget {
  final BookingModel booking;
  final String userId;

  const AdminModal({
    super.key,
    required this.booking,
    required this.userId,
  });

  @override
  State<StatefulWidget> createState() {
    return _AdminModalState();
  }
}

class _AdminModalState extends State<AdminModal> {
  bool _isUpdating = false;

  // Helper function to format the date
  String formatDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  // Helper function to format the time
  String formatTime(DateTime? time) {
    if (time == null) return 'N/A';
    return DateFormat.jm().format(time);
  }

  // Function to update the booking status and dispatch the event
  Future<void> _updateBookingStatus(String status) async {
    setState(() {
      _isUpdating = true; // Show loading state
    });

    final updatedBooking = widget.booking.copyWith(status: status);

    // Dispatch the UpdateBooking event through the Bloc
    context.read<BookingBloc>().add(
          UpdateBooking(
            booking: updatedBooking,
            bookingId: widget.booking.id!,
            userId: widget.userId,
          ),
        );

    // Wait for the state to update
    if (mounted) {
      final state = await context.read<BookingBloc>().stream.firstWhere(
          (state) => state is BookingSuccess || state is BookingFailure);
      if (state is BookingSuccess) {
        Navigator.of(context).pop(); // Close the dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking ${status.capitalize()}')),
        );
      } else if (state is BookingFailure) {
        setState(() {
          _isUpdating = false; // Stop loading on error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update booking: ${state.error}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Booking Details',
            style: TextStyle(color: Colors.black),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking by: ${widget.booking.fullName}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              widget.booking.hotelName != null
                  ? 'Hotel: ${widget.booking.hotelName}'
                  : 'Restaurant: ${widget.booking.restaurantName ?? ''}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              widget.booking.hotelName != null
                  ? 'Room: ${widget.booking.roomName ?? 'N/A'}'
                  : 'Table Number: ${widget.booking.tableNumber ?? 'N/A'}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check-in/out:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Check-in: ${formatDate(widget.booking.checkInDate)} / '
              'Check-out: ${formatDate(widget.booking.checkOutDate)}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Time in/out:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Time-in: ${formatTime(widget.booking.timeOfArrival)} / '
              'Time-out: ${formatTime(widget.booking.timeOfDeparture)}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Contact Information:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Full Name: ${widget.booking.fullName}',
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              'Email Address: ${widget.booking.email}',
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              'Phone Number: ${widget.booking.phoneNumber}',
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              'Address: ${widget.booking.address}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Guests:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Adults: ${widget.booking.adult}, Children: ${widget.booking.children}',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      actions: [
        if (_isUpdating)
          const CircularProgressIndicator() // Show a loading indicator
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _updateBookingStatus('accepted'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Accept'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _updateBookingStatus('rejected'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Reject'),
              ),
            ],
          ),
      ],
      backgroundColor: Colors.white,
    );
  }
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
