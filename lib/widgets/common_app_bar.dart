// lib/widgets/common_app_bar.dart
import 'package:flutter/material.dart';

import '../utils/colors.dart';

AppBar buildCommonAppBar({
  required String title,
  Color backgroundColor = const Color(0xFF885F3A),
  Color titleColor = const Color(0xFFFFFAF6),
  bool showProfileButton = true,
  VoidCallback? onProfilePressed,
  bool showBackButton = true,
  VoidCallback? onBackPressed,
}) {
  List<Widget> actions = [];

  if (showProfileButton) {
    actions.add(
      IconButton(
        icon: Icon(Icons.person, color: hexColor('#FFFAF6')),
        onPressed: onProfilePressed ?? () => print('Кнопка профиля нажата'),
      ),
    );
  }

  return AppBar(
    title: Text(title, style: TextStyle(color: titleColor)),
    backgroundColor: backgroundColor,
    actions: actions,
    leading: showBackButton
        ? IconButton(
      icon: Icon(Icons.arrow_back, color: titleColor),
      onPressed: onBackPressed,
    )
        : null,
  );
}