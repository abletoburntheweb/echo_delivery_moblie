// lib/screens/agreement_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/profile_screen.dart';
import '../utils/colors.dart';
import '../widgets/common_app_bar.dart';

class AgreementScreen extends StatelessWidget {
  const AgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        title: 'ECHO corp',
        showProfileButton: true,
        onProfilePressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ),
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: hexColor('#885F3A').withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Персональное соглашение',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''
Съешь ещё этих мягких французских булок, да выпей чаю

Всё ускоряющаяся эволюция компьютерных технологий предъявила жёсткие требования к производителям как собственно вычислительной техники, так и периферийных устройств.

Юный директор целиком сжевал весь объём продукции фундука (товара дефицитного и деликатесного), идя энергично через хрустящий камыш.

Расчешись! Объявляю: туфли у камина, где этот хищный ёж цаплю задел.
                  ''',
                  style: const TextStyle(fontSize: 20, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}