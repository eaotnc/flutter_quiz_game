import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quiz_game/utils/constant.dart';
import 'package:flutter_quiz_game/widgets/CategoryCard.dart';
import 'package:flutter_quiz_game/widgets/HeaderBaged.dart';

import 'models/CategoryModel.dart';

void main() {
  runApp(const MyApp());
}

class Category {
  final String name;
  final String imageUrl;

  const Category({
    required this.name,
    required this.imageUrl,
  });
}

final categories = [
  const Category(
    name: 'Film and TV',
    imageUrl: 'assets/movie.png',
  ),
  const Category(
    name: 'Science',
    imageUrl: 'assets/science.png',
  ),
  const Category(
    name: 'History',
    imageUrl: 'assets/coliseum.png',
  ),
  const Category(
    name: 'General',
    imageUrl: 'assets/earth.png',
  )
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CategoryModel(),
        child: MaterialApp(
          title: 'Flutter quiz game',
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
          home: const MyHomePage(title: ''),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int score = 3253;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text('Flutter Quiz Game',
                style: TextStyle(
                    color: Colors.white60,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            HeaderBadge(score: score),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text('Select the Quiz Category to Start a Game',
                  style: TextStyle(color: Colors.white54, fontSize: 15.0)),
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    category: categories[index].name,
                    imageUrl: categories[index].imageUrl,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
