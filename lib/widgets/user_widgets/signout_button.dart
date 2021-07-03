import 'package:flutter/material.dart';

class TextAndArrowButton extends StatelessWidget {
  const TextAndArrowButton({
    @required this.width,
    @required this.height,
    @required this.title,
  });

  final double width;
  final double height;
  final String title;

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = height * 0.01;
    final double horizontalPadding = width * 0.05;

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.fromLTRB(
            horizontalPadding, verticalPadding, horizontalPadding, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Container(
              width: this.width * 0.8,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              width: this.width * 0.1,
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: this.height * 0.02,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
