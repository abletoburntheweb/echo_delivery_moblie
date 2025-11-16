import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'register_screen.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = true;
  bool _siteBlocked = false;
  String _maintenanceText = '';

  @override
  void initState() {
    super.initState();
    print('🚀 LoginScreen initState');
    _checkSiteStatus();
  }

  Future<void> _checkSiteStatus() async {
    try {
      print('🔄 НАЧАЛО ПРОВЕРКИ СТАТУСА САЙТА...');

      final status = await ApiService.getSiteStatus();

      print('📊 ПОЛУЧЕННЫЙ ОТВЕТ ОТ API:');
      print('   - site_blocked: ${status['site_blocked']}');
      print('   - maintenance_text: "${status['maintenance_text']}"');
      print('   - maintenance_mode: ${status['maintenance_mode']}');

      setState(() {
        _siteBlocked = status['site_blocked'] ?? false;
        _maintenanceText = status['maintenance_text'] ?? '';
        _isLoading = false;
      });

      print('🎯 ФИНАЛЬНОЕ СОСТОЯНИЕ В ПРИЛОЖЕНИИ:');
      print('   - _siteBlocked: $_siteBlocked');
      print('   - _maintenanceText: "$_maintenanceText"');
      print('   - _isLoading: $_isLoading');

    } catch (e) {
      print('❌ КРИТИЧЕСКАЯ ОШИБКА ПРИ ПРОВЕРКЕ СТАТУСА: $e');
      setState(() {
        _isLoading = false;
        _siteBlocked = false;
        _maintenanceText = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 BUILD ВЫЗВАН:');
    print('   - _isLoading: $_isLoading');
    print('   - _siteBlocked: $_siteBlocked');
    print('   - _maintenanceText: "$_maintenanceText"');

    // Показываем экран загрузки
    if (_isLoading) {
      print('👀 ПОКАЗЫВАЕМ ЭКРАН ЗАГРУЗКИ');
      return Scaffold(
        appBar: buildCommonAppBar(
          title: 'ECHO corp',
          showProfileButton: true,
          showBackButton: false,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Проверяем статус сайта...'),
            ],
          ),
        ),
      );
    }

    // 🔴 ЕСЛИ САЙТ ЗАБЛОКИРОВАН - показываем экран блокировки
    if (_siteBlocked) {
      print('🚫 ПОКАЗЫВАЕМ ЭКРАН БЛОКИРОВКИ САЙТА');
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
                Icon(Icons.build, size: 64, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  'Технические работы',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  _maintenanceText.isNotEmpty
                      ? _maintenanceText
                      : 'В настоящее время ведутся технические работы.\nПожалуйста, попробуйте позже.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _checkSiteStatus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: textOnPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Проверить снова'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ✅ ЕСЛИ САЙТ НЕ ЗАБЛОКИРОВАН - показываем нормальный экран логина
    print('✅ ПОКАЗЫВАЕМ НОРМАЛЬНЫЙ ЭКРАН ЛОГИНА');
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
                // Информационное сообщение о тех работах (если есть, но сайт не заблокирован)
                if (_maintenanceText.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.orange),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _maintenanceText,
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

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