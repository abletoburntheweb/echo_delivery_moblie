// lib/utils/phone_input_formatter.dart
import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final oldText = oldValue.text;
    final newText = newValue.text;

    if (newText.length < oldText.length) {
      String digits = newText.replaceAll(RegExp(r'\D'), '');

      if (digits.isEmpty) {
        return newValue.copyWith(text: '', selection: TextSelection.collapsed(offset: 0));
      }

      return _formatDigits(digits, newValue);
    }

    String digits = newText.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 10) {
      return oldValue;
    }

    return _formatDigits(digits, newValue);
  }

  TextEditingValue _formatDigits(String digits, TextEditingValue current) {
    String formatted = '';

    if (digits.startsWith('7') || digits.startsWith('8')) {
      if (digits.length > 1) {
        digits = digits.substring(1);
      }
      formatted = '+7 (';
    } else {
      formatted = '+7 (';
    }

    if (digits.length >= 3) {
      formatted += digits.substring(0, 3) + ') ';
      if (digits.length >= 6) {
        formatted += digits.substring(3, 6) + '-';
        if (digits.length >= 8) {
          formatted += digits.substring(6, 8) + '-';
          if (digits.length >= 10) {
            formatted += digits.substring(8, 10);
          } else {
            formatted += digits.substring(8);
          }
        } else {
          formatted += digits.substring(6);
        }
      } else {
        formatted += digits.substring(3);
      }
    } else {
      formatted += digits;
    }

    return current.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}