import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/inTalksProductsData.dart';
import '../../providers/userProductsData.dart';
import '../../screens/see_all_screen.dart';
import '../category_seeall_button.dart';

class TextAndSeeAllButton extends StatelessWidget {
  const TextAndSeeAllButton({
    @required this.width,
    @required this.height,
    @required this.heading,
  });

  final double width;
  final double height;
  final String heading;

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = height * 0.04;
    final double horizontalPadding = width * 0.05;

    return Container(
      padding: EdgeInsets.fromLTRB(
          horizontalPadding, verticalPadding, horizontalPadding, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Container(
            width: this.width * 0.55,
            child: Text(
              this.heading,
              style: TextStyle(
                fontSize: this.height * 0.02,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: this.width * 0.35,
            child: Align(
              alignment: Alignment.centerRight,
              child: CategoryAndSeeAllButton(
                changeCategory: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return heading == 'On Sale'
                            ? Consumer<UserProductsData>(
                                builder: (context, userProductsData, child) {
                                return SeeAllScreen(
                                  userProductsData.getUserProducts,
                                  heading,
                                );
                              })
                            : Consumer<InTalksProductsData>(
                                builder: (context, inTalksProductsData, child) {
                                return SeeAllScreen(
                                  inTalksProductsData.getInTalksProducts,
                                  heading,
                                );
                              });
                      },
                    ),
                  );
                },
                title: 'See All',
                isSelected: false,
                padding: horizontalPadding,
              ),
            ),
          )
        ],
      ),
    );
  }
}
