import 'package:flutter/material.dart';
import 'package:flutter_quiz_game/utils/constant.dart';

class HeaderBadge extends StatelessWidget {
  const HeaderBadge({
    super.key,
    required this.score,
  });

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF3c4efe),
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/avatar.png",
                width: 60,
                height: 60,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rank',
                      style: kNormalStyle.copyWith(
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    const Text(
                      '434',
                      style: kTitleStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: 1.0,
            height: 60,
            color: Colors.white,
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(90.0),
                child: Image.asset(
                  "assets/coin.jpg",
                  width: 40,
                  height: 40,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Score',
                      style: kNormalStyle.copyWith(
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    Text(
                      '$score',
                      style: kTitleStyle,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
