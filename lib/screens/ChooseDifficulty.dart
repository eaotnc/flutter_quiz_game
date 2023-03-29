import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/CategoryModel.dart';
import '../utils/constant.dart';
import '../widgets/QuizHeader.dart';
import 'quiz_screen.dart';

class ChooseDifficultyScreen extends StatefulWidget {
  const ChooseDifficultyScreen({Key? key}) : super(key: key);

  @override
  _ChooseDifficultyScreenState createState() => _ChooseDifficultyScreenState();
}

class _ChooseDifficultyScreenState extends State<ChooseDifficultyScreen> {
  void handleClick(String difficulty) {
    var categoryModel = context.read<CategoryModel>();
    categoryModel.setDifficulty(difficulty);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Consumer<CategoryModel>(
              builder: (context, model, child) {
                return QuizHeader(
                  category: model.selectedCategory,
                  imageUrl: model.categoryImageUrl,
                );
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: const Text('Choose Your Want',
                  textAlign: TextAlign.center, style: kTitleStyle),
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    handleClick('easy');
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.green[600],
                        borderRadius: BorderRadius.circular(20)),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/playtime.png',
                          width: 50,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text('Easy', style: kTitleStyle),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    handleClick('medium');
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(20)),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/teenage.png',
                          width: 50,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text('Medium', style: kTitleStyle),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    handleClick('hard');
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(20)),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/crown.png',
                          width: 50,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text('Hard', style: kTitleStyle),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
