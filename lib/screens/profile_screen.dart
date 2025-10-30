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
  late final TextEditingController _loginController;
  late final TextEditingController _companyController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _companyController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic>? userData = await AuthService.getCurrentUser();
      String? currentLogin = await AuthService.getUserLogin();

      if (userData != null) {
        setState(() {
          _loginController.text = currentLogin ?? '';
          _companyController.text = userData['company'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _emailController.text = userData['email'] ?? '';
          // _passwordController.text = userData['password'] ?? '';
        });
      } else {
        if (currentLogin != null) {
          setState(() {
            _loginController.text = currentLogin;
          });
        }
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

  Future<void> _saveProfile() async {
    final newCompany = _companyController.text;
    final newPhone = _phoneController.text;
    final newEmail = _emailController.text;
    final newPassword = _passwordController.text;

    if (newCompany.isEmpty || newPhone.isEmpty || newEmail.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пожалуйста, заполните все поля (Название фирмы, Телефон, Почта).')),
        );
      }
      return;
    }

    bool success = await AuthService.updateUser(
      newCompany.isEmpty ? null : newCompany,
      newPhone.isEmpty ? null : newPhone,
      newEmail.isEmpty ? null : newEmail,
      newPassword.isEmpty ? null : newPassword,
    );

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Профиль успешно обновлён!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при сохранении профиля.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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

              TextField(
                controller: _loginController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Логин',
                  filled: true,
                  fillColor: buttonBg,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _companyController,
                decoration: InputDecoration(
                  labelText: 'Название фирмы',
                  filled: true,
                  fillColor: buttonBg,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _phoneController,
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
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Почта',
                  filled: true,
                  fillColor: buttonBg,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Пароль (новый)',
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
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: textOnPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),

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
    );
  }
}