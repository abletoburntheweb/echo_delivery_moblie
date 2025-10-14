// lib/screens/order_confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/profile_screen.dart';
import '../utils/time_input_formatter.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart'; // Подключаем

class OrderConfirmationScreen extends StatefulWidget {
  final double totalPrice;

  const OrderConfirmationScreen({
    super.key,
    required this.totalPrice,
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  bool _accountAgreement = false;
  bool _termsAgreement = false;
  bool _privacyPolicy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        title: 'ECHO corp',
        showProfileButton: true,
        onProfilePressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ),
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: hexColor('#885F3A').withOpacity(0.1), // наш цвет с прозрачностью
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Цена
              Row(
                children: [
                  Text(
                    'Цена',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.totalPrice.toStringAsFixed(2)} ₽',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Адрес
              const Text(
                'Адрес',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: buttonBg, // наш цвет фона
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Время
              const Text(
                'Время',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _timeController,
                inputFormatters: [
                  TimeInputFormatter(), // ✅ Маска времени
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: buttonBg, // наш цвет фона
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),

              // Чекбоксы
              CheckboxListTile(
                title: const Text('Что-то про аккаунт'),
                value: _accountAgreement,
                onChanged: (value) {
                  setState(() {
                    _accountAgreement = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Вы соглашаетесь со всем'),
                value: _termsAgreement,
                onChanged: (value) {
                  setState(() {
                    _termsAgreement = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Политика конфиденциальности'),
                value: _privacyPolicy,
                onChanged: (value) {
                  setState(() {
                    _privacyPolicy = value!;
                  });
                },
              ),

              const SizedBox(height: 40),

              // Кнопка "Оплатить" — под чекбоксами
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (_addressController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Введите адрес')),
                      );
                      return;
                    }
                    if (_timeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Введите время')),
                      );
                      return;
                    }
                    if (!_accountAgreement || !_termsAgreement || !_privacyPolicy) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Подтвердите все условия')),
                      );
                      return;
                    }

                    print('Заказ оформлен!');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Заказ оформлен')),
                    );
                    Navigator.pop(context); // Закрываем экран
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // наш цвет фона кнопки
                    foregroundColor: textOnPrimary, // цвет текста на кнопке
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Оплатить', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}