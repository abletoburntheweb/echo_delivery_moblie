// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/common_app_bar.dart';
import '../utils/phone_input_formatter.dart';
import '../utils/colors.dart';
import 'login_screen.dart';
import 'agreement_screen.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _companyController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic>? userData = await AuthService.getCurrentUser();
      String? currentEmail = await AuthService.getUserEmail();

      if (userData != null) {
        setState(() {
          _companyController.text = userData['company'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _addressController.text = userData['address'] ?? ''; // ← добавлено
          _emailController.text = currentEmail ?? '';
        });
      }
    } catch (e) {
      print('Ошибка при загрузке данных профиля: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при загрузке данных: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Название фирмы
              TextField(
                controller: _companyController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Название',
                  filled: true,
                  fillColor: buttonBg,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Телефон
              TextField(
                controller: _phoneController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Телефон',
                  filled: true,
                  fillColor: buttonBg,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Адрес компании
              TextField(
                controller: _addressController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Адрес',
                  filled: true,
                  fillColor: buttonBg,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Почта (логин)
              TextField(
                controller: _emailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Почта',
                  filled: true,
                  fillColor: buttonBg,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Договор/соглашение
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AgreementScreen(),
                    ),
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
              const SizedBox(height: 20),

              // Кнопка "Выйти"
              ElevatedButton(
                onPressed: () async {
                  await AuthService.logout();
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: textOnPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: const Text('Выйти',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
