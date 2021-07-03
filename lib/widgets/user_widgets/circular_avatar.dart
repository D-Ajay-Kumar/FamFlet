import 'package:flutter/material.dart';

import '../../screens/open_image.dart';

class CircularAvatar extends StatelessWidget {
  const CircularAvatar({
    @required this.width,
    @required this.height,
    @required this.imageUrl,
  });

  final double width;
  final double height;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = height * 0.03;
    final double horizontalPadding = width * 0.05;

    return Container(
      width: this.width,
      padding: EdgeInsets.fromLTRB(
          horizontalPadding, verticalPadding, horizontalPadding, 0),
      child: GestureDetector(
        onTap: imageUrl != null
            ? () {
                Navigator.of(context)
                    .pushNamed(OpenImage.routeName, arguments: imageUrl);
              }
            : () {},
        child: Align(
          child: CircleAvatar(
            backgroundColor: const Color(0xffD8D8D8),
            backgroundImage: imageUrl != null
                ? NetworkImage(
                    imageUrl,
                  )
                : AssetImage('assets/images/defaultImage.png'),
            radius: height * 0.07,
          ),
        ),
      ),
    );
  }
}
