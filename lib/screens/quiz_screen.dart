import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_quiz_game/screens/summaryPointScreen.dart';
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
  @override
  String userAnswer = '';
  int quizIndex = 0;
  int score = 0;
  bool isLoading = false;

  List<QuizItem> _quizList = [];

  Future<void> _fetchData(String category) async {
    print('category: ${category}');
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(
        Uri.parse(
            'https://the-trivia-api.com/api/questions?categories=${category}&limit=10&difficulty=easy'),
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
      _fetchData(categoryModel.selectedCategory);
    });
  }

  void handleOnPressAnswer(String answer) {
    setState(() {
      userAnswer = answer;
    });
    _quizList[quizIndex].setUserAnswer(answer);
  }

  void handleNextQuestion() {
    setState(() {
      if (quizIndex < _quizList.length - 1) {
        setState(() {
          quizIndex++;
          userAnswer = '';
        });
      } else {}
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
            if (_quizList.length > 0)
              Container(
                height: 550,
                width: double.infinity - 40,
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
                      if (userAnswer != '')
                        Center(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  if (_quizList[quizIndex].correctAnswer ==
                                      userAnswer)
                                    Column(
                                      children: [
                                        Image.asset(
                                          'assets/checked.png',
                                          width: 60,
                                          height: 60,
                                        ),
                                        const Text('Your Correct',
                                            textAlign: TextAlign.center,
                                            style: kNormalStyle),
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
                                        const Text('Your Wrong the correct is:',
                                            textAlign: TextAlign.center,
                                            style: kNormalStyle),
                                        Text(_quizList[quizIndex].correctAnswer,
                                            style: kNormalStyle),
                                      ],
                                    ),
                                ],
                              )),
                        ),
                    ]),
              ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (quizIndex > 0) {
                          quizIndex--;
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyHomePage(),
                            ),
                          );
                        }
                      });
                    },
                    child: Image.asset(
                      'assets/previous.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      handleNextQuestion();
                    },
                    child: Image.asset(
                      'assets/next.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
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
