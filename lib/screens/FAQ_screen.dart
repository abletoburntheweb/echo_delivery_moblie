// lib/screens/faq_screen.dart
import 'package:flutter/material.dart';
import 'profile_screen.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuestionAnswer(
                      question: 'Кто мы такие?',
                      answer: 'Наша компания занимается оптовой доставкой еды в офисы. Ну а так мы просто бедные студенты...',
                    ),
                    const SizedBox(height: 20),

                    _buildQuestionAnswer(
                      question: 'Есть ли у нас сертификаты?',
                      answer: 'Конечно же у нас все есть. Ну в самом деле, кто бы нам разрешил еду продавать тогда?',
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Обратная связь',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'TG:',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      '+7(922)425-56-55',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      'echodel@gmail.com',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionAnswer({required String question, required String answer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            question,
            style: TextStyle(
              color: textOnPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          answer,
          style: TextStyle(
            color: primaryColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}