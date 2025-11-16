import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/order_confirmation_screen.dart';
import 'package:intl/intl.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';
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
          onProfilePressed: () => print('Профиль'),
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: Center(
          child: Text(
            'Дата не выбрана',
            style: TextStyle(fontSize: 20, color: primaryColor),
          ),
        ),
      );
    }

    double totalPrice = 0.0;
    for (var dish in selectedDishes) {
      totalPrice += dish.price * dish.quantity;
    }

    return Scaffold(
      appBar: buildCommonAppBar(
        title: 'ECHO corp',
        showProfileButton: true,
        onProfilePressed: () => print('Профиль'),
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
            Expanded(
              child: ListView(
                children: [
                  Text(
                    DateFormat('dd.MM.yyyy').format(selectedDate!),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ...selectedDishes.map((dish) {
                    final itemTotal = dish.price * dish.quantity;
                    return ListTile(
                      title: Text(dish.name),
                      subtitle: Text('Количество: ${dish.quantity}'),
                      trailing: Text('${itemTotal.toStringAsFixed(2)} ₽'),
                    );
                  }).toList(),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Text('Итого:', style: const TextStyle(fontSize: 18)),
                      const Spacer(),
                      Text('${totalPrice.toStringAsFixed(2)} ₽', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmationScreen(
                                selectedDate: selectedDate!,
                                selectedDishes: selectedDishes),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: const Text('Согласовать'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}