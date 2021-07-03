import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    @required this.width,
    @required this.height,
    @required this.title,
    @required this.onPressed,
    @required this.type,
  });
  final double width;
  final double height;
  final String title;
  final Function onPressed;
  final int type;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: height * 0.06,
      minWidth: width * 0.35,
      child: type == 1
          ? FlatButton(
              color: const Color(0xff000000),
              onPressed: this.onPressed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                this.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xffffffff),
                ),
              ),
            )
          : OutlineButton(
              color: const Color(0xff000000),
              borderSide: BorderSide(
                color: const Color(0xff000000),
                style: BorderStyle.solid,
                width: 1.5,
              ),
              onPressed: this.onPressed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                this.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff000000),
                ),
              ),
            ),
    );
  }
}
