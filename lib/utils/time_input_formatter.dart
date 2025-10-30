// lib/utils/time_input_formatter.dart
import 'package:flutter/services.dart';

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    text = text.replaceAll(RegExp(r'\D'), '');

    if (text.isEmpty) {
      return newValue.copyWith(text: '', selection: TextSelection.collapsed(offset: 0));
    }

    if (text.length > 4) {
      text = text.substring(0, 4);
    }

    String formatted = '';

    if (text.length >= 2) {
      int hours = int.parse(text.substring(0, 2));
      if (hours > 24) {
        hours = 24;
      }
      formatted = hours.toString().padLeft(2, '0') + ':';

      if (text.length > 2) {
        int minutes = int.parse(text.substring(2, text.length));
        if (minutes > 59) {
          minutes = 59;
        }
        formatted += minutes.toString();
      }
    } else {
      formatted = text;
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}