import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:intl/intl.dart';

class PendingModal extends StatefulWidget {
  final BookingModel booking;

  const PendingModal({super.key, required this.booking});

  @override
  _PendingModalState createState() => _PendingModalState();
}

class _PendingModalState extends State<PendingModal> {
  DateTime? _checkInDate;
  TimeOfDay? _checkInTime;
  DateTime? _checkOutDate;
  TimeOfDay? _checkOutTime;

  @override
  void initState() {
    super.initState();
    // Initialize dates with current booking values
    _checkInDate = widget.booking.checkInDate;
    _checkOutDate = widget.booking.checkOutDate;
  }

  // Format Date to 'yyyy-MM-dd'
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Select Check-in Date
  Future<void> _selectCheckInDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
      });
    }
  }

  // Select Check-in Time
  Future<void> _selectCheckInTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _checkInTime = picked;
      });
    }
  }

  // Select Check-out Date
  Future<void> _selectCheckOutDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate!.add(const Duration(days: 1)),
      firstDate: _checkInDate!.add(const Duration(days: 1)),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  // Select Check-out Time
  Future<void> _selectCheckOutTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _checkOutTime = picked;
      });
    }
  }

  // Handle Reschedule Action
  void _handleReschedule() {
    if (_checkInDate != null && _checkOutDate != null) {
      // Create an updated booking object
      final updatedBooking = widget.booking.copyWith(
        checkInDate: _checkInDate!,
        checkOutDate: _checkOutDate!,
      );

      // Dispatch the UpdateBooking event
      context.read<BookingBloc>().add(
            UpdateBooking(
              booking: updatedBooking,
              bookingId: widget.booking.id!,
            ),
          );

      Navigator.of(context).pop(); // Close the modal

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking rescheduled to ${formatDate(_checkInDate!)} - '
            '${formatDate(_checkOutDate!)}',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select valid check-in and check-out dates.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Booking'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reschedule your booking:'),
            const SizedBox(height: 20.0),
            _buildDateTimeRow(
              label: 'Check-in Date and Time:',
              dateText: _checkInDate != null
                  ? formatDate(_checkInDate!)
                  : 'No check-in date selected',
              timeText: _checkInTime != null
                  ? _checkInTime!.format(context)
                  : 'No check-in time selected',
              onSelectDate: () => _selectCheckInDate(context),
              onSelectTime: () => _selectCheckInTime(context),
            ),
            const SizedBox(height: 20.0),
            _buildDateTimeRow(
              label: 'Check-out Date and Time:',
              dateText: _checkOutDate != null
                  ? formatDate(_checkOutDate!)
                  : 'No check-out date selected',
              timeText: _checkOutTime != null
                  ? _checkOutTime!.format(context)
                  : 'No check-out time selected',
              onSelectDate: () => _selectCheckOutDate(context),
              onSelectTime: () => _selectCheckOutTime(context),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _handleReschedule,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Reschedule'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildDateTimeRow({
    required String label,
    required String dateText,
    required String timeText,
    required VoidCallback onSelectDate,
    required VoidCallback onSelectTime,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: Text(dateText, style: const TextStyle(fontSize: 16.0)),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: onSelectDate,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(timeText, style: const TextStyle(fontSize: 16.0)),
            ),
            IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: onSelectTime,
            ),
          ],
        ),
      ],
    );
  }
}
