import 'package:flutter/material.dart';

class TextUserDetails extends StatelessWidget {
  const TextUserDetails({
    @required this.width,
    @required this.height,
    this.attribute,
    this.info,
  });

  final double width;
  final double height;
  final String attribute;
  final String info;

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = height * 0.015;
    final double horizontalPadding = width * 0.05;

    return Container(
      width: this.width,
      padding: EdgeInsets.fromLTRB(
          horizontalPadding, verticalPadding, horizontalPadding, 0),
      child: Row(
        children: [
          Container(
            width: this.width * 0.25,
            child: Text(
              '$attribute',
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            width: this.width * 0.65,
            child: Text(
              '$info',
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
