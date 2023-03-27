import 'package:flutter/material.dart';
import 'package:flutter_quiz_game/main.dart';
import 'package:flutter_quiz_game/widgets/QuizHeader.dart';

import '../utils/constant.dart';

class QuizItem {
  // final String quiz_id;
  final String question;
  final List<String> choice;
  final String correctAnswer;
  final String? userAnswer;

  const QuizItem({
    // required this.quiz_id,
    required this.question,
    required this.choice,
    required this.correctAnswer,
    this.userAnswer,
  });
}

final QuizSet = [
  const QuizItem(
      question:
          'Who proclaimed Thanksgiving a national holiday in the USA in 1863?',
      choice: [
        "Abraham Lincoln",
        "George Washington",
        "Ronald Regan",
        "Thomas Jefferson"
      ],
      correctAnswer: 'Abraham Lincoln'),
  const QuizItem(
      question: "Which word is defined as 'a commotion or fuss'?",
      choice: ["Donkey Engine", "Taradiddle", "Bibble", "Kerfuffle"],
      correctAnswer: "Kerfuffle"),
  const QuizItem(
      question: "Which University, founded in 1636, is the oldest in the USA?",
      choice: ["Yale", "Cornell", "Harvard", "Princeton"],
      correctAnswer: "Harvard"),
];

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  String userAnswer = '';
  int quizIndex = 0;

  void handleOnPressAnswer(String answer) {
    print('answer: ${answer}');
    setState(() {
      userAnswer = answer;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(),
                ),
              );
            },
            child: Container(
              height: 60,
              margin: const EdgeInsets.fromLTRB(0, 20, double.infinity, 0),
              child: const Icon(
                Icons.chevron_left,
                color: Colors.grey,
                size: 40.0,
              ),
            ),
          ),
          const QuizHeader(
            category: 'General',
            imageUrl: 'assets/earth.png',
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Level Normal',
                style: kNormalStyle.copyWith(color: Colors.grey[700])),
          ),
          Container(
            width: double.infinity - 40,
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                '${quizIndex + 1}. ${QuizSet[quizIndex].question}',
                style: kTitleStyle.copyWith(letterSpacing: 0.4),
              ),
              SizedBox(height: 20),
              for (var choiceItem in QuizSet[quizIndex].choice)
                AnswerButton(
                    choice: choiceItem,
                    userAnswer: userAnswer,
                    handleOnPressAnswer: handleOnPressAnswer),
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
                    setState(() {
                      if (quizIndex < QuizSet.length - 1) {
                        quizIndex++;
                      } else {}
                    });
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
        padding: const EdgeInsets.all(20.0),
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
