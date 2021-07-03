import 'package:flutter/material.dart';

import './product_tile.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    @required this.width,
    @required this.height,
    @required this.itemsList,
  });

  final double width;
  final double height;
  final List itemsList;

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = height * 0.03;
    final double horizontalPadding = width * 0.05;

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Wrap(
        spacing: width * 0.05,
        runSpacing: width * 0.05,
        children: (itemsList.map((product) {
          return ProductTile(
            product: product,
            height: this.height,
            width: this.width,
          );
        }).toList()),
      ),
    );
  }
}
