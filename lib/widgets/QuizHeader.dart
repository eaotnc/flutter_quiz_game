import 'package:flutter/material.dart';
import 'package:flutter_quiz_game/main.dart';
import 'package:flutter_quiz_game/screens/quiz_screen.dart';

import '../utils/constant.dart';

class QuizHeader extends StatelessWidget {
  QuizHeader({
    super.key,
    required this.category,
    required this.imageUrl,
    this.isComplete,
  });

  final String category;
  final String imageUrl;
  bool? isComplete;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Container(
        height: 100.0,
        width: double.infinity,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category',
                  style: kNormalStyle.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      letterSpacing: .5),
                ),
                Text(
                  category,
                  style: kTitleStyle.copyWith(
                      fontWeight: FontWeight.normal, letterSpacing: .5),
                ),
                if (isComplete != null)
                  Image.asset(
                    imageUrl,
                    width: 60,
                    height: 60,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
