import 'package:flutter/material.dart';

import '../../widgets/product_tile.dart';
import '../../models/product.dart';

class UserProducts extends StatelessWidget {
  const UserProducts({
    @required this.width,
    @required this.height,
    @required this.productsList,
  });

  final double width;
  final double height;
  final List<Product> productsList;

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = height * 0.015;
    final double horizontalPadding = width * 0.05;

    return Container(
      width: this.width,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Wrap(
        spacing: width * 0.05,
        runSpacing: width * 0.05,
        children: productsList
            .sublist(0, productsList.length > 2 ? 2 : productsList.length)
            .map((e) {
          return ProductTile(
            product: e,
            height: this.height,
            width: this.width,
          );
        }).toList(),
      ),
    );
  }
}
