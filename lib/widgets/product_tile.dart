import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../services/firebaseServices.dart';
import '../widgets/delete_alert.dart';
import '../main.dart';
import '../providers/productsData.dart';
import '../providers/inTalksProductsData.dart';
import '../providers/userProductsData.dart';
import '../screens/product_detail_screen.dart';

class ProductTile extends StatelessWidget {
  final dynamic product;
  final double height;
  final double width;

  const ProductTile({
    Key key,
    this.product,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductsData productsData =
        Provider.of<ProductsData>(context, listen: false);
    final UserProductsData userProductsData =
        Provider.of<UserProductsData>(context, listen: false);
    final InTalksProductsData inTalksProductsData =
        Provider.of<InTalksProductsData>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0x11000000),
            blurRadius: 1.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              !product.isAvailable
                  ? showModalBottomSheet(
                      backgroundColor: const Color(0x00ffffff),
                      context: context,
                      builder: (ctx) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(width * 0.03),
                              topRight: Radius.circular(width * 0.03),
                            ),
                          ),
                          padding: EdgeInsets.only(
                              top: height * 0.05,
                              bottom: height * 0.04,
                              left: width * 0.05,
                              right: width * 0.05),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: width,
                                child: Text(
                                  'Have You Sold Your Product?',
                                  style: TextStyle(
                                      fontSize: height * 0.02,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                width: width,
                                child: Text(
                                    'If Yes, Then Delete Your Product Otherwise Repost It'),
                              ),
                              SizedBox(
                                height: height * 0.2,
                              ),
                              Wrap(
                                spacing: width * 0.05,
                                children: [
                                  // delete Button
                                  ButtonTheme(
                                    height: height * 0.06,
                                    minWidth: width * 0.35,
                                    child: OutlineButton(
                                      color: const Color(0xff000000),
                                      borderSide: BorderSide(
                                        color: const Color(0xff000000),
                                        style: BorderStyle.solid,
                                        width: 1.5,
                                      ),
                                      onPressed: () async {
                                        Navigator.of(context).pop();

                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DeleteAlert(
                                                navigatorKey.currentContext,
                                                product,
                                              );
                                            });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // repost Button
                                  ButtonTheme(
                                    height: height * 0.06,
                                    minWidth: width * 0.35,
                                    child: FlatButton(
                                      color: const Color(0xff000000),
                                      onPressed: () {
                                        inTalksProductsData
                                            .removeProduct(product.uid);
                                        userProductsData.addProduct(
                                            product, 'New');
                                        productsData.addProduct(product, 'New');
                                        product.isAvailable = true;
                                        FirebaseServices()
                                            .uploadProductAvailability(
                                                navigatorKey.currentContext,
                                                product.uid,
                                                true);
                                        Navigator.of(context).pop();
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        'Repost',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Navigator.of(context).pushNamed(
                      ProductDetailScreen.routeName,
                      arguments: product.uid,
                    );
            },
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    color: const Color(0xffe8e8e8),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        product.pictureUrls[0],
                      ),
                    ),
                  ),
                  width: width * 0.42,
                  height: height * 0.25,
                ),
                Container(
                  width: width * 0.42,
                  height: height * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff00C217),
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    margin: EdgeInsets.all(width * 0.025),
                    padding: EdgeInsets.all(width * 0.02),
                    child: Text(
                      '₹ ${(product.price)}',
                      style: TextStyle(
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: product.branch == null
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))
                  : null,
            ),
            padding: EdgeInsets.all(height * 0.007),
            width: width * 0.42,
            child: Text(
              ((() {
                if (product.title.length > 40) {
                  return product.title.substring(0, 40) + '...';
                } else {
                  return product.title;
                }
              }())),
            ),
          ),
          product.category == 'Academics'
              ? Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                  ),
                  padding: EdgeInsets.fromLTRB(height * 0.007, height * 0.002,
                      height * 0.007, height * 0.007),
                  width: width * 0.42,
                  child: Text(
                    '${product.branch}, Sem: ${product.sem}',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              : Container(
                  color: const Color(0xffffffff),
                  width: width * 0.42,
                ),
        ],
      ),
    );
  }
}
