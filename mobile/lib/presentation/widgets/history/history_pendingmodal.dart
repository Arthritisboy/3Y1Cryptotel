import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PendingModal extends StatefulWidget {
  const PendingModal({super.key});

  @override
  _PendingModalState createState() => _PendingModalState();
}

class _PendingModalState extends State<PendingModal> {
  DateTime? _checkInDate; 
  TimeOfDay? _checkInTime;
  DateTime? _checkOutDate; 
  TimeOfDay? _checkOutTime; 


  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date); 
  }


  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2101), 
    );
    if (picked != null && picked != _checkInDate) {
      setState(() {
        _checkInDate = picked;
      });
    }
  }


  Future<void> _selectCheckInTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _checkInTime) {
      setState(() {
        _checkInTime = picked; 
      });
    }
  }


  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate != null ? _checkInDate!.add(const Duration(days: 1)) : DateTime.now().add(const Duration(days: 2)),
      firstDate: _checkInDate != null ? _checkInDate!.add(const Duration(days: 1)) : DateTime.now().add(const Duration(days: 2)), 
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _checkOutDate) {
      setState(() {
        _checkOutDate = picked; 
      });
    }
  }


  Future<void> _selectCheckOutTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _checkOutTime) {
      setState(() {
        _checkOutTime = picked;
      });
    }
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: const Text('Are you sure you want to cancel your booking?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking Cancelled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Booking'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Would you like to cancel or reschedule this booking?'),
            const SizedBox(height: 20.0),
            const Text(
              'Check-in Date and Time:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _checkInDate != null
                        ? 'Check-in: ${formatDate(_checkInDate!)}'
                        : 'No check-in date selected',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectCheckInDate(context); 
                  },
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _checkInTime != null
                        ? 'Time: ${_checkInTime!.format(context)}'
                        : 'No check-in time selected',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () {
                    _selectCheckInTime(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Check-out Date and Time:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _checkOutDate != null
                        ? 'Check-out: ${formatDate(_checkOutDate!)}'
                        : 'No check-out date selected',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectCheckOutDate(context); 
                  },
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _checkOutTime != null
                        ? 'Time: ${_checkOutTime!.format(context)}'
                        : 'No check-out time selected',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () {
                    _selectCheckOutTime(context); 
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            ElevatedButton(
              onPressed: () {
                if (_checkInDate != null && _checkInTime != null && _checkOutDate != null && _checkOutTime != null) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Booking rescheduled from ${formatDate(_checkInDate!)} at ${_checkInTime!.format(context)}'
                            ' to ${formatDate(_checkOutDate!)} at ${_checkOutTime!.format(context)}',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select both check-in and check-out dates and times')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Reschedule'),
            ),
            const SizedBox(width: 10), 
            ElevatedButton(
              onPressed: () {
                _confirmCancel(context); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Cancel Booking'),
            ),
          ],
        ),
        const Divider(),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }
}
