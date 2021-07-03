import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../screens/see_all_screen.dart';
import './category_seeall_button.dart';
import './products_grid.dart';
import '../providers/productsData.dart';

class CategoriesAndSeeAllAndProducts extends StatefulWidget {
  const CategoriesAndSeeAllAndProducts({
    @required this.width,
    @required this.height,
  });

  final double width;
  final double height;

  @override
  _CategoriesAndSeeAllAndProductsState createState() =>
      _CategoriesAndSeeAllAndProductsState();
}

class _CategoriesAndSeeAllAndProductsState
    extends State<CategoriesAndSeeAllAndProducts> {
  bool thisChanges;

  double verticalPadding;
  double horizontalPadding;
  bool isAcademics = true;
  bool isNonAcademics = false;

  int _index = 0;

  @override
  void initState() {
    verticalPadding = widget.height * 0.05;
    horizontalPadding = widget.width * 0.05;
    super.initState();
  }

  void selectAcedamics() {
    if (isAcademics) return;

    setState(() {
      isAcademics = true;
      isNonAcademics = false;
      _index = 0;
    });
  }

  void selectNonAcedamics() {
    if (isNonAcademics) return;

    setState(() {
      isAcademics = false;
      isNonAcademics = true;
      _index = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProductsData allProductsData =
        Provider.of<ProductsData>(context, listen: false);

    return Column(
      children: [
        //categories and sell all
        Container(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            verticalPadding,
            horizontalPadding,
            0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Row(
                  children: [
                    //acedamics button
                    CategoryAndSeeAllButton(
                      title: 'Academics',
                      changeCategory: this.selectAcedamics,
                      isSelected: this.isAcademics,
                      padding: horizontalPadding,
                    ),

                    //non-acedamics button
                    CategoryAndSeeAllButton(
                      title: 'Non Academics',
                      changeCategory: this.selectNonAcedamics,
                      isSelected: this.isNonAcademics,
                      padding: horizontalPadding,
                    ),
                  ],
                ),
              ),
              CategoryAndSeeAllButton(
                changeCategory: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return Consumer<ProductsData>(
                        builder: (context, productsData, child) {
                      return SeeAllScreen(
                        isAcademics
                            ? allProductsData.getAcademicsProduct
                            : allProductsData.getNonAcademicsProduct,
                        isAcademics ? 'Academic' : 'Non Academic',
                      );
                    });
                  }));
                },
                title: 'See All',
                isSelected: false,
                padding: horizontalPadding,
              ),
            ],
          ),
        ),

        //products
        Consumer<ProductsData>(
          builder: (context, productsData, child) {
            return productsData == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : IndexedStack(
                    index: _index,
                    children: [
                      ProductsGrid(
                          width: widget.width,
                          height: widget.height,
                          itemsList: productsData.getAcademicsProduct.sublist(
                              0,
                              productsData.getAcademicsProduct.length > 6
                                  ? 6
                                  : productsData.getAcademicsProduct.length)),
                      ProductsGrid(
                        width: widget.width,
                        height: widget.height,
                        itemsList: productsData.getNonAcademicsProduct.sublist(
                            0,
                            productsData.getNonAcademicsProduct.length > 6
                                ? 6
                                : productsData.getNonAcademicsProduct.length),
                      ),
                    ],
                  );
          },
        ),

        SizedBox(
          height: widget.height * 0.05,
        )
      ],
    );
  }
}
