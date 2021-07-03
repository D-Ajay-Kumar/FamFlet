import 'package:flutter/material.dart';

import '../../screens/open_image.dart';

class ProductImageList extends StatelessWidget {
  const ProductImageList({
    @required this.height,
    @required this.width,
    @required this.imageList,
  });

  final double height;
  final double width;
  final List<dynamic> imageList;

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = height * 0.03;
    final double horizontalPadding = width * 0.05;

    return Container(
      padding: EdgeInsets.only(top: verticalPadding),
      height: height * 0.35,
      child: ListView.builder(
        padding: EdgeInsets.only(left: horizontalPadding),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: horizontalPadding,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(OpenImage.routeName,
                    arguments: imageList[index]);
              },
              child: Container(
                width: height * 0.35,
                decoration: BoxDecoration(
                  color: const Color(0xffD8D8D8),
                  borderRadius: BorderRadius.circular(5.0),
                  image: DecorationImage(
                    image: NetworkImage(
                      imageList[index],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: imageList.length,
      ),
    );
  }
}
