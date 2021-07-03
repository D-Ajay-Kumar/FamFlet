import 'package:flutter/material.dart';

class HeadingContent extends StatelessWidget {
  const HeadingContent({
    @required this.width,
    @required this.height,
    @required this.heading,
    @required this.content,
  });
  final double width;
  final double height;
  final String heading;
  final String content;

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = height * 0.04;
    final double horizontalPadding = width * 0.05;
    return Container(
      padding: EdgeInsets.fromLTRB(
          horizontalPadding, verticalPadding, horizontalPadding, 0),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              heading,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: height * 0.01),
            child: Text(
              content,
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
