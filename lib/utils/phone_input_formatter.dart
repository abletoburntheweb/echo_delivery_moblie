// lib/utils/phone_input_formatter.dart
import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newText = newValue.text;

    if (newText.isEmpty) {
      return newValue;
    }

    final digitsOnly = newText.replaceAll(RegExp(r'[^\d]'), '');

    final limitedDigits = digitsOnly.length > 11 ? digitsOnly.substring(0, 11) : digitsOnly;

    String formatted = limitedDigits;

    if (formatted.isNotEmpty) {
      if (formatted.startsWith('8')) {
        formatted = '7${formatted.substring(1)}';
      } else if (!formatted.startsWith('7')) {
        formatted = '7$formatted';
      }
    }

    final buffer = StringBuffer();
    buffer.write('+7');

    if (formatted.length > 1) {
      final number = formatted.substring(1);

      if (number.isNotEmpty) {
        final part1 = number.length >= 3 ? number.substring(0, 3) : number;
        buffer.write('($part1');

        if (number.length > 3) {
          final part2 = number.length >= 6 ? number.substring(3, 6) : number.substring(3);
          buffer.write(')$part2');

          if (number.length > 6) {
            final part3 = number.length >= 8 ? number.substring(6, 8) : number.substring(6);
            buffer.write('-$part3');

            if (number.length > 8) {
              final part4 = number.substring(8);
              buffer.write('-$part4');
            }
          }
        } else {
          buffer.write(')');
        }
      }
    }

    final formattedText = buffer.toString();

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}