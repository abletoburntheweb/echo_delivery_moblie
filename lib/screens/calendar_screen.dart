// lib/screens/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/selected_dishes_screen.dart';
import 'package:intl/intl.dart';
import 'FAQ_screen.dart';
import 'profile_screen.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: buildCommonAppBar(
          title: 'ECHO corp',
          titleColor: textOnPrimary,
          backgroundColor: primaryColor,
          showProfileButton: true,
          onProfilePressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          ),
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Расписание на ближайшие 2 недели',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Text(
                DateFormat('MMMM yyyy').format(DateTime.now()).toUpperCase(),
                style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.w500),
              ),
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
                      child: _buildCalendarGrid(context),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        if (_selectedDate != null) {
                          print('Выбрана дата: ${DateFormat('dd.MM.yyyy').format(_selectedDate!)}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectedDishesScreen(
                                selectedDate: _selectedDate!,
                              ),
                            ),
                          );
                        } else {
                          print('Дату не выбрали');
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

              const SizedBox(height: 30),

              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FAQScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: textOnPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'FAQ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    const weekdays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) =>
          Text(day, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
      ).toList(),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(14, (index) => today.add(Duration(days: index)));

    final firstDayOfWeek = today.weekday;
    final List<DateTime?> paddedDates = <DateTime?>[];
    for (int i = 0; i < firstDayOfWeek - 1; i++) {
      paddedDates.add(null);
    }
    paddedDates.addAll(dates);

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
        if (date == null) {
          return Container();
        }

        final day = date.day;
        final isToday = date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;
        final isSelected = _selectedDate != null &&
            date.year == _selectedDate!.year &&
            date.month == _selectedDate!.month &&
            date.day == _selectedDate!.day;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? buttonBg : (isToday ? buttonBg : Colors.transparent),
              border: Border.all(color: textOnPrimary),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: isSelected
                      ? textOnSecondary
                      : isToday && !isSelected
                      ? accentColor
                      : textOnPrimary,
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