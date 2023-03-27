import 'package:flutter/material.dart';
import 'package:flutter_quiz_game/screens/quiz_screen.dart';

import '../utils/constant.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.imageUrl,
  });

  final String category;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const QuizScreen(),
          ),
        );
      },
      child: Container(
        height: 100.0,
        width: double.infinity - 20,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            Image.asset(
              imageUrl,
              width: 60,
              height: 60,
            ),
            const SizedBox(width: 30),
            Text(
              category,
              style: kTitleStyle.copyWith(
                  fontWeight: FontWeight.normal, letterSpacing: .5),
            )
          ],
        ),
      ),
    );
  }
}
