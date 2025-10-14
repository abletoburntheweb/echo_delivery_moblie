// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'register_screen.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart'; // Подключаем

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        title: 'ECHO corp',
        showProfileButton: true,
        showBackButton: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: hexColor('#885F3A').withOpacity(0.1), // наш цвет с прозрачностью
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              TextField(
                decoration: InputDecoration(
                  labelText: 'Логин',
                  filled: true,
                  fillColor: buttonBg, // наш цвет фона
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  filled: true,
                  fillColor: buttonBg, // наш цвет фона
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CalendarScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // наш цвет фона кнопки
                  foregroundColor: textOnPrimary, // цвет текста на кнопке
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Войти', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: Text(
                  'Регистрация',
                  style: TextStyle(color: primaryColor), // наш цвет текста
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}