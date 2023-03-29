import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_quiz_game/main.dart';
import 'package:flutter_quiz_game/widgets/QuizHeader.dart';
import 'package:provider/provider.dart';

import '../models/CategoryModel.dart';
import '../utils/constant.dart';

class QuizItem {
  final String id;
  final String question;
  final List choice;
  final String correctAnswer;
  String? userAnswer;

  QuizItem({
    required this.id,
    required this.question,
    required this.choice,
    required this.correctAnswer,
  });

  void setUserAnswer(String answer) {
    userAnswer = answer;
  }

  factory QuizItem.fromJson(Map<String, dynamic> json) {
    List choice = json['incorrectAnswers'];
    choice.add(json['correctAnswer']);
    choice.shuffle();
    return QuizItem(
      id: json['id'],
      question: json['question'],
      choice: choice,
      correctAnswer: json['correctAnswer'],
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String userAnswer = '';
  int quizIndex = 0;
  int score = 0;
  bool isLoading = false;
  bool isComplete = false;
  List<QuizItem> _quizList = [];

  Future<void> _fetchData(String category, String difficulty) async {
    print('difficulty: ${difficulty}');
    print('category: ${category}');
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(
        Uri.parse(
            'https://the-trivia-api.com/api/questions?categories=${category}&limit=10&difficulty=$difficulty'),
      );
      if (response.statusCode == 200) {
        List jsonMap = jsonDecode(response.body);
        List<QuizItem> questions =
            jsonMap.map((data) => QuizItem.fromJson(data)).toList();
        setState(() {
          _quizList = questions;
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        // _movie = null;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var categoryModel = Provider.of<CategoryModel>(context, listen: false);
      _fetchData(categoryModel.selectedCategory, categoryModel.difficulty);
    });
  }

  void handleOnPressAnswer(String answer) {
    int newScore =
        (_quizList[quizIndex].correctAnswer == answer) ? score + 1 : score;
    setState(() {
      userAnswer = answer;
      score = newScore;
    });
    _quizList[quizIndex].setUserAnswer(answer);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowAnswerDialog(
              quizList: _quizList,
              quizIndex: quizIndex,
              userAnswer: userAnswer);
        }).then((value) => handleNextQuestion());
  }

  void handleNextQuestion() {
    setState(() {
      if (quizIndex < _quizList.length - 1) {
        setState(() {
          quizIndex++;
          userAnswer = '';
        });
      } else {
        setState(() {
          isComplete = true;
        });
      }
    });
  }

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
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('Level Normal',
                  style: kNormalStyle.copyWith(color: Colors.grey[700])),
            ),
            if (isLoading) const CircularProgressIndicator(),
            if (_quizList.length > 0 && isComplete == false)
              Container(
                height: 550,
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${quizIndex + 1}. ${_quizList[quizIndex].question}',
                        style: kTitleStyle.copyWith(letterSpacing: 0.4),
                      ),
                      SizedBox(height: 20),
                      for (var choiceItem in _quizList[quizIndex].choice)
                        AnswerButton(
                            choice: choiceItem,
                            userAnswer: userAnswer,
                            handleOnPressAnswer: handleOnPressAnswer),
                    ]),
              ),
            if (isComplete) CompleteQuizWidget(score: score),
          ],
        ),
      ),
    );
  }
}

class ShowAnswerDialog extends StatelessWidget {
  const ShowAnswerDialog({
    super.key,
    required List<QuizItem> quizList,
    required this.quizIndex,
    required this.userAnswer,
  }) : _quizList = quizList;

  final List<QuizItem> _quizList;
  final int quizIndex;
  final String userAnswer;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Container(
          height: 170.0,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                if (_quizList[quizIndex].correctAnswer == userAnswer)
                  Column(
                    children: [
                      Image.asset(
                        'assets/checked.png',
                        width: 60,
                        height: 60,
                      ),
                      const Text('Your Correct',
                          textAlign: TextAlign.center, style: kNormalStyle),
                    ],
                  )
                else
                  Column(
                    children: [
                      Image.asset(
                        'assets/cross.png',
                        width: 60,
                        height: 60,
                      ),
                      const Text('Your Wrong ',
                          textAlign: TextAlign.center, style: kNormalStyle),
                      Text(
                          'the correct is: ${_quizList[quizIndex].correctAnswer}',
                          style: kNormalStyle),
                    ],
                  ),
              ],
            ),
          )),
    );
  }
}

class CompleteQuizWidget extends StatelessWidget {
  const CompleteQuizWidget({
    super.key,
    required this.score,
  });

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          'Your Completed The Quiz',
          style: kTitleStyle.copyWith(letterSpacing: 0.4),
        ),
        const SizedBox(
          height: 50,
        ),
        if (score < 5)
          Image.asset(
            'assets/sad.png',
            width: 120,
            height: 120,
          )
        else if (score == 5)
          Image.asset(
            'assets/neutral.png',
            width: 120,
            height: 120,
          )
        else if (score > 5)
          Image.asset(
            'assets/thumbs-ups.png',
            width: 120,
            height: 120,
          ),
        const SizedBox(
          height: 50,
        ),
        Text(
          'Total Score: $score',
          style: kTitleStyle.copyWith(letterSpacing: 0.4),
        ),
        const SizedBox(
          height: 50,
        ),
        TextButton(
            onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  )
                },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.yellow[800],
                  borderRadius: BorderRadius.circular(20)),
              child: Text('Back To HomePage', style: kNormalStyle),
            ))
      ]),
    );
  }
}

class AnswerButton extends StatefulWidget {
  const AnswerButton({
    super.key,
    required this.choice,
    required this.userAnswer,
    required this.handleOnPressAnswer,
  });

  final String choice;
  final String userAnswer;
  final Function handleOnPressAnswer;

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        widget.handleOnPressAnswer(widget.choice);
      },
      child: AnimatedContainer(
        width: double.infinity - 20,
        padding: const EdgeInsets.all(15.0),
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: widget.userAnswer == widget.choice
              ? Colors.amber
              : Colors.white60,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          widget.choice,
          style: kNormalStyle.copyWith(letterSpacing: 0.4),
        ),
      ),
    );
  }
}
