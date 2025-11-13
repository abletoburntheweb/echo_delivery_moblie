// lib/screens/order_confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/profile_screen.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';
import '../models/dish.dart';
import 'calendar_screen.dart';
import 'package:intl/intl.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final DateTime selectedDate;
  final List<Dish> selectedDishes;

  const OrderConfirmationScreen({
    super.key,
    required this.selectedDate,
    required this.selectedDishes,
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final TextEditingController _addressController = TextEditingController();
  String? _selectedTime;
  bool _termsAgreement = false;

  final List<String> _timeOptions = [];

  double get totalPrice {
    double sum = 0.0;
    for (var dish in widget.selectedDishes) {
      final price = double.tryParse(dish.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      sum += price * dish.quantity;
    }
    return sum;
  }

  @override
  void initState() {
    super.initState();
    _generateTimeSlots();
    _loadUserAddress();
  }

  void _generateTimeSlots() {
    for (int hour = 11; hour <= 13; hour++) {
      for (int minute = 0; minute < 60; minute += 10) {
        if (hour == 13 && minute > 0) break;
        final formattedTime =
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
        _timeOptions.add(formattedTime);
      }
    }
  }

  Future<void> _loadUserAddress() async {
    final userData = await AuthService.getCurrentUser();
    if (userData != null && userData['address'] != null) {
      setState(() {
        _addressController.text = userData['address'];
      });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _confirmOrder() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Введите адрес доставки')));
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Выберите время доставки')));
      return;
    }
    if (!_termsAgreement) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Подтвердите согласие')));
      return;
    }

    // Сохраняем дату и блюда через AuthService
    await AuthService.saveDishesForDate(widget.selectedDate, widget.selectedDishes);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Заказ успешно оформлен!')));

    // Возврат на календарь
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const CalendarScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        title: 'ECHO corp',
        showProfileButton: true,
        onProfilePressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        ),
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Дата доставки: ${DateFormat('dd.MM.yyyy').format(widget.selectedDate)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Список блюд
            ...widget.selectedDishes.map((dish) {
              final unitPrice = double.tryParse(dish.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
              final total = unitPrice * dish.quantity;
              return ListTile(
                title: Text(dish.name),
                subtitle: Text('Количество: ${dish.quantity}'),
                trailing: Text('${total.toStringAsFixed(2)} ₽'),
              );
            }).toList(),

            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Итого:', style: TextStyle(fontSize: 18)),
                const Spacer(),
                Text('${totalPrice.toStringAsFixed(2)} ₽',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 30),

            // Адрес
            const Text('Адрес доставки', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                filled: true,
                fillColor: buttonBg,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Время
            const Text('Выберите время доставки', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: _selectedTime,
              items: _timeOptions
                  .map((time) => DropdownMenuItem(
                value: time,
                child: Text(time),
              ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedTime = value),
              decoration: InputDecoration(
                filled: true,
                fillColor: buttonBg,
                border: const OutlineInputBorder(),
              ),
              hint: const Text('Выберите время'),
            ),
            const SizedBox(height: 20),

            CheckboxListTile(
              title: const Text('Вы соглашаетесь со всем'),
              value: _termsAgreement,
              onChanged: (value) => setState(() => _termsAgreement = value ?? false),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: _confirmOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Оплатить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
