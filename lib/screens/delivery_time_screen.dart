// lib/screens/delivery_time_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/selected_dishes_screen.dart';
import 'package:intl/intl.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';
import 'order_confirmation_screen.dart';
import '../models/dish.dart';

class DeliveryTimeScreen extends StatelessWidget {
  final DateTime? selectedDate;
  final List<Dish> selectedDishes;

  const DeliveryTimeScreen({
    Key? key,
    this.selectedDate,
    required this.selectedDishes,
  }) : super(key: key);

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

    double totalPrice = 0.0;
    for (var dish in selectedDishes) {
      double unitPrice = _parsePrice(dish.price);
      totalPrice += unitPrice * dish.quantity;
    }

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
                  Navigator.pop(context, selectedDishes);
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

            Expanded(
              child: ListView(
                children: [
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
                        ...selectedDishes.map((dish) {
                          double unitPrice = _parsePrice(dish.price);
                          double itemTotalPrice = unitPrice * dish.quantity;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: hexColor('#885F3A').withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dish.name,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '30 дней',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${dish.quantity} штук',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '${itemTotalPrice.toStringAsFixed(2)} ₽',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
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
                  '${totalPrice.toStringAsFixed(2)} ₽',
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
                        totalPrice: totalPrice,
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

  double _parsePrice(String priceString) {
    String numericPart = priceString.replaceAll(RegExp(r'[^0-9.]'), '');
    try {
      return double.parse(numericPart);
    } catch (e) {
      print('Ошибка при парсинге цены: $priceString');
      return 0.0;
    }
  }
}