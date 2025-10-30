// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/common_app_bar.dart';
import '../utils/phone_input_formatter.dart';
import '../utils/colors.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = TextEditingController();
    final companyController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: buildCommonAppBar(
        title: 'ECHO corp',
        showProfileButton: true,
        onProfilePressed: () => print('Профиль на экране регистрации'),
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: hexColor('#885F3A').withOpacity(0.1),
        ),
        child: SingleChildScrollView(
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
                controller: companyController,
                decoration: InputDecoration(
                  labelText: 'Название фирмы',
                  filled: true,
                  fillColor: buttonBg,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: phoneController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                  PhoneInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: 'Телефон',
                  filled: true,
                  fillColor: buttonBg,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Почта',
                  filled: true,
                  fillColor: buttonBg,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
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
                  final company = companyController.text;
                  final phone = phoneController.text;
                  final email = emailController.text;

                  if (login.isEmpty || password.isEmpty || company.isEmpty || phone.isEmpty || email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Пожалуйста, заполните все поля.')),
                    );
                    return;
                  }

                  bool success = await AuthService.registerUser(login, password, company, phone, email);

                  if (success) {
                    print('Регистрация успешна для: $login');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Пользователь с таким логином уже существует.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: textOnPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Зарегистрироваться', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Text(
                  'Уже есть аккаунт?',
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