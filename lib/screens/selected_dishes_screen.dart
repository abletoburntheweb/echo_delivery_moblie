// lib/screens/selected_dishes_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/profile_screen.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';
import 'menu_screen.dart';
import 'delivery_time_screen.dart';

class SelectedDishesScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const SelectedDishesScreen({
    super.key,
    this.selectedDate,
  });

  @override
  State<SelectedDishesScreen> createState() => _SelectedDishesScreenState();
}

class _SelectedDishesScreenState extends State<SelectedDishesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        title: 'ECHO corp',
        onProfilePressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ),
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: hexColor('#885F3A').withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  if (widget.selectedDate != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryTimeScreen(
                          selectedDate: widget.selectedDate!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Дата не выбрана')),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Время',
                    style: TextStyle(
                      color: textOnPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: Center(
                child: Text(
                  'Пока здесь пусто',
                  style: TextStyle(
                    fontSize: 20,
                    color: primaryColor.withOpacity(0.6),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuScreen()),
                  );
                },
                backgroundColor: buttonBg,
                child: Icon(Icons.add, color: primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}