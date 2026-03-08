import 'package:flutter/cupertino.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '25:00',
        style: TextStyle(
          fontSize: 80,
          fontWeight: FontWeight.w200,
          letterSpacing: -2,
        ),
      ),
    );
  }
}