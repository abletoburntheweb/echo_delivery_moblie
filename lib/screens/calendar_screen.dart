// lib/screens/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/selected_dishes_screen.dart';
import 'package:flutterprojects/screens/profile_screen.dart';
import 'package:flutterprojects/screens/faq_screen.dart';
import 'package:intl/intl.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? _selectedDate;
  late List<DateTime> _displayedDates;
  List<String> _orderDates = [];

  @override
  void initState() {
    super.initState();
    _generateDates();
    _loadOrderDates();
  }

  void _generateDates() {
    final now = DateTime.now();
    final nextMonday = now.add(Duration(days: (8 - now.weekday) % 7));
    _displayedDates = List.generate(14, (index) => nextMonday.add(Duration(days: index)));
  }

  Future<void> _loadOrderDates() async {
    final dates = await AuthService.getOrderDates();
    setState(() {
      _orderDates = dates;
    });
  }

  bool _hasOrder(DateTime date) {
    final strDate = DateFormat('yyyy-MM-dd').format(date);
    return _orderDates.contains(strDate);
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
          onProfilePressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          ),
          showBackButton: false,
          onBackPressed: () {},
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
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
                    Expanded(child: _buildCalendarGrid(context)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_selectedDate != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectedDishesScreen(
                                selectedDate: _selectedDate!,
                              ),
                            ),
                          ).then((_) => _loadOrderDates());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Пожалуйста, выберите дату')),
                          );
                        }
                      },
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FAQScreen()),
                  );
                },
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
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        if (date == null) return Container();

        final isSelected = _selectedDate != null &&
            date.year == _selectedDate!.year &&
            date.month == _selectedDate!.month &&
            date.day == _selectedDate!.day;

        final hasOrder = _hasOrder(date);

        return GestureDetector(
          onTap: () => setState(() => _selectedDate = date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? buttonBg
                  : hasOrder
                  ? Colors.orangeAccent
                  : Colors.transparent,
              border: Border.all(color: textOnPrimary),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  color: isSelected ? textOnSecondary : textOnPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
