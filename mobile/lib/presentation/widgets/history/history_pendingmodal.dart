import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/presentation/widgets/utils_widget/custom_dialog.dart';
import 'package:intl/intl.dart';

class PendingModal extends StatefulWidget {
  final BookingModel booking;
  final String userId;

  const PendingModal({
    super.key,
    required this.booking,
    required this.userId,
  });

  @override
  State<StatefulWidget> createState() {
    return _PendingModalState();
  }
}

class _PendingModalState extends State<PendingModal> {
  DateTime? _checkInDate;
  TimeOfDay? _checkInTime;
  DateTime? _checkOutDate;
  TimeOfDay? _checkOutTime;

  @override
  void initState() {
    super.initState();
    _checkInDate = widget.booking.checkInDate;
    _checkOutDate = widget.booking.checkOutDate;
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dateTime);
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
      });
    }
  }

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

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate!.add(const Duration(days: 1)),
      firstDate: _checkInDate!,
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

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

  Future<void> _confirmReschedule() async {
    if (_checkInDate == _checkOutDate) {
      _showValidationError(
          'Check-in and check-out cannot be on the same day without a 12-hour difference.');
      return;
    }

    if (!_validateTimeDifference()) {
      _showValidationError(
          'For same-day bookings, there must be at least 12 hours between check-in and check-out.');
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Reschedule'),
        content:
            const Text('Are you sure you want to reschedule this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (result == true) {
      _handleReschedule();
    }
  }

  bool _validateTimeDifference() {
    if (_checkInDate != null &&
        _checkOutDate != null &&
        _checkInTime != null &&
        _checkOutTime != null) {
      final checkInDateTime = DateTime(
        _checkInDate!.year,
        _checkInDate!.month,
        _checkInDate!.day,
        _checkInTime!.hour,
        _checkInTime!.minute,
      );

      final checkOutDateTime = DateTime(
        _checkOutDate!.year,
        _checkOutDate!.month,
        _checkOutDate!.day,
        _checkOutTime!.hour,
        _checkOutTime!.minute,
      );

      if (_checkInDate!.isAtSameMomentAs(_checkOutDate!)) {
        final timeDifference = checkOutDateTime.difference(checkInDateTime);
        return timeDifference.inHours >= 12;
      }
    }
    return true;
  }

  Future<void> _showValidationError(String message) async {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Invalid Booking',
        description: message,
        buttonText: 'Close',
        onButtonPressed: () => Navigator.of(context).pop(),
        onSecondButtonPressed: () {},
      ),
    );
  }

  void _handleReschedule() {
    final updatedBooking = widget.booking.copyWith(
      checkInDate: _checkInDate!,
      checkOutDate: _checkOutDate!,
    );

    context.read<BookingBloc>().add(
          UpdateBooking(
            booking: updatedBooking,
            bookingId: widget.booking.id!,
            userId: widget.userId,
          ),
        );

    context.read<BookingBloc>().add(FetchBookings(userId: widget.userId));

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Booking rescheduled to ${formatDate(_checkInDate!)} - ${formatDate(_checkOutDate!)}',
        ),
      ),
    );
  }

  void _handleCancel() {
    final cancelledBooking = widget.booking.copyWith(status: 'cancelled');

    context.read<BookingBloc>().add(
          UpdateBooking(
            booking: cancelledBooking,
            bookingId: widget.booking.id!,
            userId: widget.userId,
          ),
        );

    context.read<BookingBloc>().add(FetchBookings(userId: widget.userId));

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking has been cancelled.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Booking'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reschedule or cancel your booking:'),
            const SizedBox(height: 20.0),
            _buildDateTimeRow(
              label: 'Check-in Date and Time:',
              dateText: _checkInDate != null
                  ? formatDate(_checkInDate!)
                  : 'No check-in date selected',
              timeText: _checkInTime != null
                  ? formatTime(_checkInTime!)
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
                  ? formatTime(_checkOutTime!)
                  : 'No check-out time selected',
              onSelectDate: () => _selectCheckOutDate(context),
              onSelectTime: () => _selectCheckOutTime(context),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _confirmReschedule,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Reschedule'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _handleCancel,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Center(child: Text('Cancel Booking')),
              ),
            ),
          ],
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
                child: Text(dateText, style: const TextStyle(fontSize: 16.0))),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: onSelectDate,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Text(timeText, style: const TextStyle(fontSize: 16.0))),
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
