import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

class SeeAllScreen extends StatelessWidget {
  static const routeName = '/SeeAllScreen';

  final List dataList;
  final String title;

  SeeAllScreen(this.dataList, this.title);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
              return;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: width,
                    padding: EdgeInsets.fromLTRB(
                        width * 0.05, height * 0.03, width * 0.05, 0),
                    child: Text(
                      title + ': All Products',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ProductsGrid(
                    width: width,
                    height: height,
                    itemsList: dataList,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
