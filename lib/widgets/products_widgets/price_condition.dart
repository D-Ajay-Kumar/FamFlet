import 'package:flutter/material.dart';

class PriceCondition extends StatelessWidget {
  const PriceCondition({
    @required this.width,
    @required this.height,
    @required this.price,
    @required this.condition,
  });

  final double width;
  final double height;
  final String price;
  final String condition;

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
            width: width * 0.5,
            child: Text(
              '₹ $price',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.w600,
                color: const Color(0xff00C217),
              ),
            ),
          ),
          Container(
            width: width * 0.4,
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Condition: $condition',
                  style: TextStyle(fontWeight: FontWeight.w300),
                )),
          )
        ],
      ),
    );
  }
}
