import 'package:flutter/material.dart';

class LessonHeader extends StatelessWidget {
  const LessonHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Chi tiết bài học',
        style: TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.bold,
          fontFamily: 'Lexend',
        ),
      ),
    );
  }
}
