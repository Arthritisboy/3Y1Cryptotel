import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> selectTime(
    BuildContext context, TextEditingController controller) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (picked != null) {
    final now = DateTime.now();
    final DateTime selectedTime =
        DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
    String formattedTime = DateFormat.Hm().format(selectedTime); // "HH:mm"
    controller.text = formattedTime;
  }
}

Future<void> selectDate(
    BuildContext context, TextEditingController controller) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2101),
  );
  if (picked != null) {
    String formattedDate = picked.toIso8601String();
    controller.text = formattedDate;
  }
}

DateTime? combineDateAndTime(String date, String time) {
  if (date.isEmpty || time.isEmpty) return null;
  try {
    final parsedDate = DateTime.parse(date);

    // Use the correct DateFormat to parse "HH:mm" format (24-hour time)
    final cleanedTime = time
        .trim()
        .replaceAll('\u00A0', '')
        .trim(); // Clean non-breaking spaces
    final parsedTime = DateFormat.Hm().parse(cleanedTime); // "HH:mm" format

    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day,
        parsedTime.hour, parsedTime.minute);
  } catch (e) {
    print("Error parsing date or time: $e");
    return null;
  }
}
