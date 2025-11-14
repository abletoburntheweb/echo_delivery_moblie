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
    final emailController = TextEditingController();
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Почта',
                    filled: true,
                    fillColor: buttonBg,
                    border: const OutlineInputBorder(),
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
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Пожалуйста, введите email и пароль.')),
                      );
                      return;
                    }

                    try {
                      print('🧠 Используем УМНЫЙ вход...');

                      final result = await AuthService.smartLogin(email, password);

                      print('✅ Умный вход успешен: $email');

                      final isLocalStorage = result['local_storage'] == true;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isLocalStorage
                              ? 'Вход успешен'
                              : 'Вход успешен'
                          ),
                          backgroundColor: isLocalStorage ? Colors.orange : Colors.green,
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const CalendarScreen()),
                      );
                    } catch (e) {
                      print('❌ Ошибка умного входа: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка входа: $e')),
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
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
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
      ),
    );
  }
}
