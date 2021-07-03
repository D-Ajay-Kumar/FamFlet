import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../models/product.dart';
import '../providers/productsData.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> suggestionList = [];
  List<Product> productsData;

  void refillList(List<String> query) {
    setState(
      () {
        var regex = new RegExp("(?:${query.join('|')})", caseSensitive: false);

        suggestionList = query[0] == ''
            ? []
            : productsData
                .where(
                  (product) =>
                      regex.hasMatch(product.title) ||
                      regex.hasMatch(product.branch ?? '⛰️') ||
                      regex.hasMatch(product.subject ?? '⛰️'),
                )
                .toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // to listen when the user adds a product himself
    productsData =
        Provider.of<ProductsData>(context, listen: true).getProductsList;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    return Container(
      height: height,
      width: width,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // to push the search results grid below the enabled text field
                  Container(
                    padding: EdgeInsets.fromLTRB(width * 0.05, height * 0.03,
                        width * 0.05, height * 0.01),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      enabled: false,
                    ),
                  ),

                  // displays the search result grid or the empty svg
                  suggestionList.length == 0
                      ? Container(
                          //color: Colors.red,
                          height: height * 0.5,
                          padding: EdgeInsets.fromLTRB(
                              width * 0.05, height * 0.01, width * 0.05, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            //mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/search.svg',
                                height: width * 0.35,
                                color: const Color(0xffe8e8e8),
                              ),
                              SizedBox(
                                height: height * 0.05,
                              ),
                              Text(
                                'Search Notes, Assignments,\nCodes, Books, Instruments etc.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xffa8a8a8),
                                ),
                              )
                            ],
                          ),
                        )
                      : ProductsGrid(
                          width: width,
                          height: height,
                          itemsList: suggestionList,
                        ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                ],
              ),
            ),

            // the enabled custom text field stacked above the disabled one
            Container(
              color: const Color(0xffffffff),
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, height * 0.03, width * 0.05, height * 0.01),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: const Color(0xffefefef),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                        height: height * 0.025,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        focusNode: FocusNode(),
                        cursorColor: const Color(0xff000000),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          refillList(value.trim().split(new RegExp('\\s+')));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
