import 'package:flutter/material.dart';

class BottomNavigationButtons extends StatelessWidget {
  final double bottomNavHeight = AppBar().preferredSize.height;

  final double deviceWidth;
  final String button1Title;
  final Function button1OnPresses;
  final String button2Title;
  final Function button2OnPresses;

  BottomNavigationButtons(
      {Key key,
      this.deviceWidth,
      this.button1Title,
      this.button1OnPresses,
      this.button2Title,
      this.button2OnPresses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0x11000000),
            blurRadius: 1.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      height: bottomNavHeight,
      child: Row(
        children: [
          GestureDetector(
            onTap: button1OnPresses,
            child: Container(
              width: deviceWidth * 0.5,
              height: bottomNavHeight,
              color: Colors.white,
              child: Container(
                child: Center(
                  child: Text(
                    button1Title,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: deviceWidth * 0.5,
            color: Colors.white,
            height: bottomNavHeight,
            padding: EdgeInsets.symmetric(
                horizontal: bottomNavHeight * 0.075,
                vertical: bottomNavHeight * 0.075),
            child: FlatButton(
              color: const Color(0xff000000),
              onPressed: button2OnPresses,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Center(
                child: Text(
                  button2Title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
