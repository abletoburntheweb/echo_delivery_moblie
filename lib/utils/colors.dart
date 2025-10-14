import 'package:flutter/material.dart';

Color hexColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})$').hasMatch(hex), 'Некорректный HEX-цвет: $hex');
  return Color(int.parse('FF${hex.substring(1)}', radix: 16));
}

// Именованные цвета
Color get appBarBg => hexColor('#885F3A');
Color get appBarText => hexColor('#FFFAF6');
Color get primaryColor => hexColor('#885F3A'); // основной цвет
Color get secondaryColor => hexColor('#FFFAF6'); // вспомогательный
Color get accentColor => Colors.red; // если хочешь оставить красный
Color get containerBg => hexColor('#885F3A'); // фон контейнера
Color get buttonBg => hexColor('#FFFAF6'); // фон кнопки
Color get buttonText => hexColor('#885F3A'); // текст на кнопке
Color get textOnPrimary => hexColor('#FFFAF6'); // текст на темном фоне
Color get textOnSecondary => hexColor('#885F3A'); // текст на светлом фоне