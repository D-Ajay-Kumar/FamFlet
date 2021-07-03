import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../screens/user_registration_screen.dart';

class TextAndEditButton extends StatelessWidget {
  const TextAndEditButton({
    @required this.width,
    @required this.height,
    @required this.title,
  });

  final double width;
  final double height;
  final String title;

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = height * 0.03;
    final double horizontalPadding = width * 0.05;

    return Container(
      padding: EdgeInsets.fromLTRB(
          horizontalPadding, verticalPadding, horizontalPadding * 0.5, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: this.height * 0.02,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/edit.svg',
              color: const Color(0xff484848),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                UserRegistrationScreen.routeName,
              );
            },
          ),
        ],
      ),
    );
  }
}
