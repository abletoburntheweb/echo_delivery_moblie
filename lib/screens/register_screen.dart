// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/common_app_bar.dart';
import '../utils/phone_input_formatter.dart';
import '../utils/colors.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void dispose() {
    companyController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
    super.dispose();
  }

  bool _isEmailValid(String email) {
    return RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    ).hasMatch(email);
  }

  void _validateAndRegister() async {
    final address = addressController.text.trim();
    final company = companyController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Проверка на пустые поля
    if (address.isEmpty || company.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля.')),
      );
      return;
    }

    // Проверка email
    if (!_isEmailValid(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, введите корректный адрес почты.')),
      );
      return;
    }

    // Регистрация
    bool success = await AuthService.registerUser(password, company, phone, email,  address: address);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Регистрация успешна!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пользователь с таким email уже существует.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

              // Название компании
              TextField(
                controller: companyController,
                decoration: InputDecoration(
                  labelText: 'Название фирмы',
                  filled: true,
                  fillColor: buttonBg,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Физический адрес
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Адрес компании',
                  filled: true,
                  fillColor: buttonBg,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Телефон
              TextField(
                controller: phoneController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  PhoneInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: '+7 (___) ___-__-__',
                  hintText: '+7 (___) ___-__-__',
                  filled: true,
                  fillColor: buttonBg,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              // Email с валидацией
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Почта',
                  filled: true,
                  fillColor: buttonBg,
                  border: const OutlineInputBorder(),
                  errorText: emailController.text.isNotEmpty && !_isEmailValid(emailController.text)
                      ? 'Некорректный адрес почты'
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}), // Обновляем UI при вводе
              ),
              const SizedBox(height: 20),

              // Пароль
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  filled: true,
                  fillColor: buttonBg,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _validateAndRegister,
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