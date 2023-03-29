import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/CategoryModel.dart';
import '../utils/constant.dart';
import '../widgets/QuizHeader.dart';

class SummaryPointScreen extends StatefulWidget {
  const SummaryPointScreen({Key? key}) : super(key: key);

  @override
  _SummaryPointScreenState createState() => _SummaryPointScreenState();
}

class _SummaryPointScreenState extends State<SummaryPointScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: const Text('Summary Point Screen', style: kTitleStyle),
            ),
            Consumer<CategoryModel>(
              builder: (context, model, child) {
                return QuizHeader(
                  category: model.selectedCategory,
                  imageUrl: model.categoryImageUrl,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
