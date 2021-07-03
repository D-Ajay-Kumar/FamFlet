import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../screens/bookmarks_screen.dart';

class NameBookmark extends StatelessWidget {
  const NameBookmark({
    @required this.width,
    @required this.height,
    @required this.name,
  });

  final double width;
  final double height;
  final String name;

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = height * 0.03;
    final double horizontalPadding = width * 0.05;

    return Container(
      padding: EdgeInsets.fromLTRB(
          horizontalPadding, verticalPadding, horizontalPadding, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Container(
            width: this.width * 0.8,
            child: Text(
              'Hello, $name',
              style: TextStyle(
                fontSize: this.height * 0.025,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //open saved posts
              Navigator.of(context).pushNamed(
                BookmarksScreen.routeName,
              );
            },
            child: Container(
              width: this.width * 0.1,
              child: Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset('assets/icons/bookmark.svg'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
