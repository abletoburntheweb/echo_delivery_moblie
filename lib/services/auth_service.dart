// lib/services/auth_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _prefsKeyUser = 'current_user';
  static const String _prefsKeyUsers = 'registered_users';
  static const String _prefsKeyUserLogin = 'current_user_login';

  static Future<bool> registerUser(String login, String password, String company, String phone, String email) async {
    final prefs = await SharedPreferences.getInstance();

    final usersJson = prefs.getString(_prefsKeyUsers);
    Map<String, dynamic> users = {};
    if (usersJson != null) {
      users = Map<String, dynamic>.from(json.decode(usersJson));
    }

    if (users.containsKey(login)) {
      return false;
    }

    users[login] = {
      'password': password,
      'company': company,
      'phone': phone,
      'email': email,
    };

    await prefs.setString(_prefsKeyUsers, json.encode(users));
    return true;
  }

  static Future<bool> loginUser(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();

    final usersJson = prefs.getString(_prefsKeyUsers);
    if (usersJson == null) {
      return false;
    }

    Map<String, dynamic> users = Map<String, dynamic>.from(json.decode(usersJson));

    if (users.containsKey(login) && users[login]['password'] == password) {
      await prefs.setString(_prefsKeyUser, json.encode(users[login]));
      await prefs.setString(_prefsKeyUserLogin, login);
      return true;
    }

    return false;
  }

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_prefsKeyUser);
    return userJson != null && prefs.getString(_prefsKeyUserLogin) != null;
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_prefsKeyUser);
    if (userJson != null) {
      return Map<String, dynamic>.from(json.decode(userJson));
    }
    return null;
  }

  static Future<String?> getUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsKeyUserLogin);
  }

  static Future<bool> updateUser(String? newCompany, String? newPhone, String? newEmail, String? newPassword) async {
    final prefs = await SharedPreferences.getInstance();

    String? currentLogin = await getUserLogin();
    if (currentLogin == null) {
      print('Ошибка: Не удалось получить логин текущего пользователя для обновления.');
      return false;
    }

    final usersJson = prefs.getString(_prefsKeyUsers);
    if (usersJson == null) {
      print('Ошибка: Не удалось загрузить список пользователей для обновления.');
      return false;
    }

    Map<String, dynamic> users = Map<String, dynamic>.from(json.decode(usersJson));

    if (!users.containsKey(currentLogin)) {
      print('Ошибка: Пользователь с логином $currentLogin не найден в списке для обновления.');
      return false;
    }

    Map<String, dynamic> userData = Map<String, dynamic>.from(users[currentLogin]);

    if (newCompany != null) userData['company'] = newCompany;
    if (newPhone != null) userData['phone'] = newPhone;
    if (newEmail != null) userData['email'] = newEmail;
    if (newPassword != null && newPassword.isNotEmpty) {
      userData['password'] = newPassword;
    }

    users[currentLogin] = userData;

    await prefs.setString(_prefsKeyUsers, json.encode(users));

    await prefs.setString(_prefsKeyUser, json.encode(userData));

    return true;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKeyUser);
    await prefs.remove(_prefsKeyUserLogin);
  }
}