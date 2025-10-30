// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'register_screen.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: buildCommonAppBar(
        title: 'ECHO corp',
        showProfileButton: true,
        showBackButton: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: hexColor('#885F3A').withOpacity(0.1),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              TextField(
                controller: loginController,
                decoration: InputDecoration(
                  labelText: 'Логин',
                  filled: true,
                  fillColor: buttonBg,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  filled: true,
                  fillColor: buttonBg,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () async {
                  final login = loginController.text;
                  final password = passwordController.text;

                  if (login.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Пожалуйста, введите логин и пароль.')),
                    );
                    return;
                  }

                  bool success = await AuthService.loginUser(login, password);

                  if (success) {
                    print('Вход успешен для: $login');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const CalendarScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Неверный логин или пароль.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: textOnPrimary,
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
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}