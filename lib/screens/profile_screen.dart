// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/common_app_bar.dart';
import '../utils/phone_input_formatter.dart';
import '../utils/colors.dart';
import 'login_screen.dart';
import 'agreement_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = TextEditingController();
    final companyController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Builder(
      builder: (context) => Scaffold(
        appBar: buildCommonAppBar(
          title: 'ECHO corp',
          showProfileButton: true,
          onProfilePressed: () => print('Профиль — уже здесь'),
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
                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AgreementScreen()),
                    );
                  },
                  child: Text(
                    'Договор/соглашение',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: textOnPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Выйти', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}