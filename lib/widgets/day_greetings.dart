import 'package:flutter/material.dart';

class DayGreetings extends StatelessWidget {
  const DayGreetings({
    @required this.width,
    @required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = width * 0.05;

    return Container(
      width: this.width,
      padding: EdgeInsets.fromLTRB(horizontalPadding, 2, horizontalPadding, 0),
      child: Text(
        ((() {
          if (DateTime.now().hour > 5 && DateTime.now().hour < 12) {
            return 'Good Morning 🌤️';
          } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 18) {
            return 'Good Afternoon ☀️';
          } else {
            return 'Good Evening 🌙';
          }
        }())),
        style: TextStyle(
          fontSize: this.height * 0.02,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
