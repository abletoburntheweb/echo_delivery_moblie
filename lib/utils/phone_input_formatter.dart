// lib/utils/phone_input_formatter.dart
import 'package:flutter/services.dart';
import 'dart:math' show min;

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Разрешаем удаление без форматирования
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    // Извлекаем только цифры
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Обрабатываем: если первая цифра 8 или 7 — отбрасываем её (номер без кода страны)
    String cleanDigits;
    if (digits.startsWith('8') || digits.startsWith('7')) {
      cleanDigits = digits.substring(1); // убираем первую 7/8
    } else {
      cleanDigits = digits;
    }

    // Максимум 10 цифр номера (после +7)
    if (cleanDigits.length > 10) {
      cleanDigits = cleanDigits.substring(0, 10);
    }

    // Форматируем
    String formatted = '+7';
    if (cleanDigits.length > 0) {
      formatted += ' (${cleanDigits.substring(0, min(cleanDigits.length, 3))}';
    }
    if (cleanDigits.length > 3) {
      formatted += ') ${cleanDigits.substring(3, min(cleanDigits.length, 6))}';
    }
    if (cleanDigits.length > 6) {
      formatted += '-${cleanDigits.substring(6, min(cleanDigits.length, 8))}';
    }
    if (cleanDigits.length > 8) {
      formatted += '-${cleanDigits.substring(8)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}