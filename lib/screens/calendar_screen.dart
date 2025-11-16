import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/selected_dishes_screen.dart';
import 'package:flutterprojects/screens/profile_screen.dart';
import 'package:flutterprojects/screens/faq_screen.dart';
import 'package:intl/intl.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? _selectedDate;
  late List<DateTime> _displayedDates;
  List<String> _orderDates = [];
  bool _isLoading = false;
  bool _maintenanceMode = false;
  String _maintenanceText = '';

  @override
  void initState() {
    super.initState();
    _generateDates();
    _checkSiteStatus();
    _loadOrderDates();
  }

  Future<void> _checkSiteStatus() async {
    try {
      final status = await ApiService.getSiteStatus();

      setState(() {
        _maintenanceMode = status['maintenance_mode'] ?? false;
        _maintenanceText = status['maintenance_dates']?['display_text'] ?? '';
      });
    } catch (e) {
      print('❌ Ошибка проверки статуса сайта: $e');
    }
  }

  void _generateDates() {
    final now = DateTime.now();
    final nextMonday = now.add(Duration(days: (8 - now.weekday) % 7));
    _displayedDates = List.generate(14, (index) => nextMonday.add(Duration(days: index)));
  }

  Future<void> _loadOrderDates() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      print('🔄 Загрузка дат заказов...');

      final apiDates = await AuthService.getOrderDates();

      if (mounted) {
        setState(() {
          _orderDates = apiDates;
          _isLoading = false;
        });
      }

      print('✅ Заказы из API: ${apiDates.length} дат');

    } catch (e) {
      print('❌ Ошибка загрузки заказов: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки заказов: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  bool _hasOrder(DateTime date) {
    final strDate = DateFormat('yyyy-MM-dd').format(date);
    return _orderDates.contains(strDate);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _navigateToSelectedDishes() {
    if (_selectedDate != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectedDishesScreen(
            selectedDate: _selectedDate!,
          ),
        ),
      ).then((_) {
        _loadOrderDates();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, выберите дату'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToFAQ() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FAQScreen()),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: buildCommonAppBar(
          title: 'ECHO corp',
          titleColor: textOnPrimary,
          backgroundColor: primaryColor,
          showProfileButton: true,
          onProfilePressed: _navigateToProfile,
          showBackButton: false,
          onBackPressed: () {},
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Только информационное сообщение о тех работах (если есть)
              if (_maintenanceMode && _maintenanceText.isNotEmpty) ...[
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

              const SizedBox(height: 10),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    _buildWeekdayHeader(),
                    const SizedBox(height: 10),
                    Expanded(
                      child: _isLoading
                          ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : _buildCalendarGrid(context),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _navigateToSelectedDishes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBg,
                        foregroundColor: buttonText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: const Text('Принять', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToFAQ,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('FAQ', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    final weekdays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map((day) => Text(
        day,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final firstDayWeekday = _displayedDates.first.weekday;
    final List<DateTime?> paddedDates = [];

    for (int i = 1; i < firstDayWeekday; i++) {
      paddedDates.add(null);
    }
    paddedDates.addAll(_displayedDates);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paddedDates.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final date = paddedDates[index];
        if (date == null) return const SizedBox.shrink();

        final isSelected = _selectedDate != null &&
            date.year == _selectedDate!.year &&
            date.month == _selectedDate!.month &&
            date.day == _selectedDate!.day;

        final hasOrder = _hasOrder(date);
        final isToday = _isToday(date);

        return GestureDetector(
          onTap: () => _onDateSelected(date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? buttonBg
                  : hasOrder
                  ? Colors.orangeAccent
                  : Colors.transparent,
              border: Border.all(
                color: isToday ? Colors.yellow : textOnPrimary,
                width: isToday ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected ? buttonText : textOnPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  if (hasOrder)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 6,
                      height: 6,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}