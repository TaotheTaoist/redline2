import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthdayCal {
  // Method to select a date using date picker
  static Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  // Method to select time using time picker
  static Future<void> selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      controller.text = selectedTime.format(context);
    }
  }
}
