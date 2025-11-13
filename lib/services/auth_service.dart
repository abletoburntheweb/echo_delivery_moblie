// lib/services/auth_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/dish.dart';

class AuthService {
  static const String _prefsKeyUser = 'current_user';
  static const String _prefsKeyUsers = 'registered_users';
  static const String _prefsKeyUserEmail = 'current_user_email';
  static const String _prefsKeyUserOrders = 'user_order_dates';
  static const String _prefsKeyUserDishes = 'user_order_dishes'; // блюда по дате

  /// Регистрация пользователя
  static Future<bool> registerUser(
      String password, String company, String phone, String email,
      {String? address}) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_prefsKeyUsers);
    Map<String, dynamic> users = {};
    if (usersJson != null) {
      users = Map<String, dynamic>.from(json.decode(usersJson));
    }

    if (users.containsKey(email)) return false;

    users[email] = {
      'password': password,
      'company': company,
      'phone': phone,
      'email': email,
      'address': address ?? '',
    };

    await prefs.setString(_prefsKeyUsers, json.encode(users));
    return true;
  }

  /// Авторизация
  static Future<bool> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_prefsKeyUsers);
    if (usersJson == null) return false;

    Map<String, dynamic> users = Map<String, dynamic>.from(json.decode(usersJson));

    if (users.containsKey(email) && users[email]['password'] == password) {
      await prefs.setString(_prefsKeyUser, json.encode(users[email]));
      await prefs.setString(_prefsKeyUserEmail, email);
      return true;
    }

    return false;
  }

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_prefsKeyUser);
    return userJson != null && prefs.getString(_prefsKeyUserEmail) != null;
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_prefsKeyUser);
    if (userJson != null) {
      return Map<String, dynamic>.from(json.decode(userJson));
    }
    return null;
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsKeyUserEmail);
  }

  static Future<bool> updateUser({
    String? newCompany,
    String? newPhone,
    String? newEmail,
    String? newPassword,
    String? newAddress,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? currentEmail = await getUserEmail();
    if (currentEmail == null) return false;

    final usersJson = prefs.getString(_prefsKeyUsers);
    if (usersJson == null) return false;

    Map<String, dynamic> users = Map<String, dynamic>.from(json.decode(usersJson));
    if (!users.containsKey(currentEmail)) return false;

    Map<String, dynamic> userData = Map<String, dynamic>.from(users[currentEmail]);

    if (newCompany != null) userData['company'] = newCompany;
    if (newPhone != null) userData['phone'] = newPhone;
    if (newEmail != null && newEmail.isNotEmpty) {
      users.remove(currentEmail);
      currentEmail = newEmail;
      userData['email'] = newEmail;
    }
    if (newPassword != null && newPassword.isNotEmpty) userData['password'] = newPassword;
    if (newAddress != null) userData['address'] = newAddress;

    users[currentEmail] = userData;

    await prefs.setString(_prefsKeyUsers, json.encode(users));
    await prefs.setString(_prefsKeyUser, json.encode(userData));
    await prefs.setString(_prefsKeyUserEmail, currentEmail);

    return true;
  }

  /// Сохранение даты заказа (без дубликатов)
  static Future<void> addOrderDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final strDate = DateFormat('yyyy-MM-dd').format(date);

    final ordersJson = prefs.getString(_prefsKeyUserOrders);
    List<String> orders = [];
    if (ordersJson != null) {
      try {
        orders = List<String>.from(json.decode(ordersJson));
      } catch (_) {
        orders = [];
      }
    }

    if (!orders.contains(strDate)) {
      orders.add(strDate);
      await prefs.setString(_prefsKeyUserOrders, json.encode(orders));
    }
  }

  static Future<void> removeOrderDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final strDate = DateFormat('yyyy-MM-dd').format(date);

    final ordersJson = prefs.getString(_prefsKeyUserOrders);
    if (ordersJson == null) return;

    List<String> orders = [];
    try {
      orders = List<String>.from(json.decode(ordersJson));
    } catch (_) {
      orders = [];
    }

    if (orders.contains(strDate)) {
      orders.remove(strDate);
      await prefs.setString(_prefsKeyUserOrders, json.encode(orders));
    }
  }

  static Future<List<String>> getOrderDates() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString(_prefsKeyUserOrders);
    if (ordersJson == null) return [];
    try {
      return List<String>.from(json.decode(ordersJson));
    } catch (_) {
      return [];
    }
  }

  /// Сохраняем блюда для даты
  static Future<void> saveDishesForDate(DateTime date, List<Dish> dishes) async {
    final prefs = await SharedPreferences.getInstance();
    final strDate = DateFormat('yyyy-MM-dd').format(date);

    final allDishesJson = prefs.getString(_prefsKeyUserDishes);
    Map<String, dynamic> allDishes = {};
    if (allDishesJson != null) {
      try {
        allDishes = Map<String, dynamic>.from(json.decode(allDishesJson));
      } catch (_) {
        allDishes = {};
      }
    }

    allDishes[strDate] = dishes.map((d) => d.toJson()).toList();
    await prefs.setString(_prefsKeyUserDishes, json.encode(allDishes));

    // Автоматически добавляем дату в список заказов
    await addOrderDate(date);
  }

  /// Получаем блюда для даты
  static Future<List<Dish>> getDishesForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final strDate = DateFormat('yyyy-MM-dd').format(date);

    final allDishesJson = prefs.getString(_prefsKeyUserDishes);
    if (allDishesJson == null) return [];

    Map<String, dynamic> allDishes = {};
    try {
      allDishes = Map<String, dynamic>.from(json.decode(allDishesJson));
    } catch (_) {
      return [];
    }

    if (!allDishes.containsKey(strDate)) return [];

    final List<dynamic> dishesList = allDishes[strDate];
    return dishesList.map((d) => Dish.fromJson(Map<String, dynamic>.from(d))).toList();
  }

  static Future<void> removeDishesForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final strDate = DateFormat('yyyy-MM-dd').format(date);

    final allDishesJson = prefs.getString(_prefsKeyUserDishes);
    if (allDishesJson == null) return;

    Map<String, dynamic> allDishes = {};
    try {
      allDishes = Map<String, dynamic>.from(json.decode(allDishesJson));
    } catch (_) {
      return;
    }

    if (allDishes.containsKey(strDate)) {
      allDishes.remove(strDate);
      await prefs.setString(_prefsKeyUserDishes, json.encode(allDishes));
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKeyUser);
    await prefs.remove(_prefsKeyUserEmail);
  }
}
