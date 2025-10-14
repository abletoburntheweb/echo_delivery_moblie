// lib/screens/delivery_time_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/selected_dishes_screen.dart';
import 'package:intl/intl.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';
import 'order_confirmation_screen.dart';

class DeliveryTimeScreen extends StatelessWidget {
  final DateTime? selectedDate;

  const DeliveryTimeScreen({
    super.key,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedDate == null) {
      return Scaffold(
        appBar: buildCommonAppBar(
          title: 'ECHO corp',
          showProfileButton: true,
          onProfilePressed: () => print('Профиль на экране времени доставки'),
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: hexColor('#885F3A').withOpacity(0.1),
          ),
          child: Center(
            child: Text(
              'Дата не выбрана',
              style: TextStyle(fontSize: 20, color: primaryColor),
            ),
          ),
        ),
      );
    }

    final dishName = 'Блюдо №1';
    final quantity = 50;
    final days = 30;
    final price = 116.90;

    return Scaffold(
      appBar: buildCommonAppBar(
        title: 'ECHO corp',
        showProfileButton: true,
        onProfilePressed: () => print('Профиль на экране времени доставки'),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectedDishesScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Изменить',
                    style: TextStyle(
                      color: textOnPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: buttonBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      DateFormat('dd.MM.yyyy').format(selectedDate!),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dishName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '$quantity штук',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$days дней',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${price.toStringAsFixed(2)} ₽',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Text(
                  'Цена',
                  style: const TextStyle(fontSize: 18),
                ),
                const Spacer(),
                Text(
                  '${price.toStringAsFixed(2)} ₽',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 40),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  print('Согласовано!');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Заказ согласован')),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderConfirmationScreen(
                        totalPrice: 116.90,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: textOnPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Согласовать', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}