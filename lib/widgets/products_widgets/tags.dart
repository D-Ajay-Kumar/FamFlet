import 'package:flutter/material.dart';

class Tags extends StatelessWidget {
  const Tags({
    @required this.width,
    @required this.height,
    this.branch,
    this.sem,
    this.subject,
  });
  final double width;
  final double height;
  final String branch;
  final String sem;
  final String subject;

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = height * 0.04;
    final double horizontalPadding = width * 0.05;

    return Container(
      padding: EdgeInsets.fromLTRB(
          horizontalPadding, verticalPadding, horizontalPadding, 0),
      width: width,
      child: Wrap(
        spacing: horizontalPadding,
        runSpacing: height * 0.03,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffe8e8e8),
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: EdgeInsets.all(horizontalPadding * 0.5),
            child: Text(branch),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffe8e8e8),
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: EdgeInsets.all(horizontalPadding * 0.5),
            child: Text('Sem: $sem'),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffe8e8e8),
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: EdgeInsets.all(horizontalPadding * 0.5),
            child: Text(subject),
          ),
        ],
      ),
    );
  }
}
