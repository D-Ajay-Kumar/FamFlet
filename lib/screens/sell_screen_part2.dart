import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'package:provider/provider.dart';

import '../main.dart';
import '../services/firebaseServices.dart';
import '../widgets/sell_form_widgets/sell_screen_constants.dart';
import '../widgets/sell_form_widgets/bottom_navigation_buttons.dart';
import '../models/product.dart';
import '../providers/appUser.dart';
import '../index.dart';
import '../constants.dart';

class SellScreenPart2 extends StatefulWidget {
  static const routeName = '/SellScreenPart2';

  @override
  _SellScreenPart2State createState() => _SellScreenPart2State();
}

class _SellScreenPart2State extends State<SellScreenPart2> {
  final _formKey = GlobalKey<FormState>();
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    final AppUser appUser =
        Provider.of<AppUser>(context, listen: false).getAppUserObject;

    Product product = ModalRoute.of(context).settings.arguments as Product;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    return Scaffold(
      bottomNavigationBar: isUploading
          ? Container(
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.05,
              ),
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Center(
                    child: Text(
                      quotes[Random().nextInt(quotes.length)],
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : BottomNavigationButtons(
              deviceWidth: width,
              button1Title: 'Back',
              button1OnPresses: () {
                Navigator.pop(context);
              },
              button2Title: 'Post',
              button2OnPresses: () async {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    isUploading = true;
                  });

                  product.sellerPhone = product.sellerPhone ?? appUser.phone;

                  product.uid = product.uid ?? null;
                  product.sellerName = appUser.name;
                  product.sellerUid = appUser.uid;
                  product.sellerBranch = appUser.branch;
                  product.sellerImage = appUser.profilePhotoUrl;
                  product.sellerCollege = appUser.college;
                  product.sellerSem = appUser.sem;
                  product.sellerDeviceToken = appUser.deviceToken;
                  product.dateTime = DateTime.now().toString();

                  for (int i = 0; i < product.pictureUrls.length; i++) {
                    if (product.pictureUrls[i].runtimeType != String) {
                      product.pictureUrls[i] = await FirebaseServices()
                          .uploadPictures(product.pictureUrls[i]);
                    }
                  }

                  FirebaseServices()
                      .uploadProduct(navigatorKey.currentContext, product);

                  setState(() {
                    isUploading = false;
                  });

                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(Index.routeName),
                  );
                }
              },
            ),
      body: SafeArea(
        child: isUploading
            ? Container()
            : Container(
                height: height,
                width: width,
                padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return;
                  },
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: height * 0.03),
                      child: Column(
                        children: [
                          //Subject
                          product.category == 'Non Academics'
                              ? Container()
                              : Column(
                                  children: [
                                    TextFormField(
                                      initialValue: product.subject,
                                      decoration: inputDecoration.copyWith(
                                        labelText: 'Subject',
                                        alignLabelWithHint: true,
                                      ),
                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        product.subject = value.trim();
                                      },
                                    ),
                                    SizedBox(
                                      height: height * 0.03,
                                    ),
                                    DropdownButtonFormField(
                                      decoration: inputDecoration.copyWith(
                                        labelText: 'Branch',
                                      ),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                      elevation: 24,
                                      icon: Icon(Icons.arrow_drop_down_rounded),
                                      value: product.branch,
                                      onChanged: (String newValue) {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        setState(() {
                                          product.branch = newValue;
                                        });
                                      },
                                      items: branches.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(
                                      height: height * 0.03,
                                    ),
                                    //Semester
                                    DropdownButtonFormField(
                                      decoration: inputDecoration.copyWith(
                                        labelText: 'Semester',
                                      ),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                      elevation: 24,
                                      icon: Icon(Icons.arrow_drop_down_rounded),
                                      value: product.sem,
                                      onChanged: (String newValue) {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        setState(() {
                                          product.sem = newValue.toString();
                                        });
                                      },
                                      items: semester.map((int value) {
                                        return DropdownMenuItem<String>(
                                          value: value.toString(),
                                          child: Text(value.toString()),
                                        );
                                      }).toList(),
                                    ),

                                    SizedBox(
                                      height: height * 0.03,
                                    ),
                                  ],
                                ),

                          //Condition
                          DropdownButtonFormField(
                            decoration: inputDecoration.copyWith(
                              labelText: 'Condition',
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Required';
                              }
                              return null;
                            },
                            elevation: 24,
                            icon: Icon(Icons.arrow_drop_down_rounded),
                            value: product.condition,
                            onChanged: (String newValue) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                product.condition = newValue;
                              });
                            },
                            items: condition.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          //I Used it for
                          TextFormField(
                            initialValue: product.iUsedItFor,
                            maxLines: 5,
                            decoration: inputDecoration.copyWith(
                              labelText: 'I Used It For',
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              product.iUsedItFor = value.trim();
                            },
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          //Price
                          TextFormField(
                            initialValue: product.price,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration.copyWith(
                              labelText: 'Price',
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Required';
                              }

                              return null;
                            },
                            onChanged: (value) {
                              product.price = value.trim();
                            },
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          //Phone Number
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            initialValue: product.sellerPhone ?? appUser.phone,
                            keyboardType: TextInputType.phone,
                            decoration: inputDecoration.copyWith(
                              labelText: 'Phone No',
                              alignLabelWithHint: true,
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              } else if (value.length != 10) {
                                return 'Invalid Phone No.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              product.sellerPhone = value.trim();
                            },
                          ),

                          SizedBox(
                            height: height * 0.1,
                          ),

                          SizedBox(
                            width: width,
                            height: height * 0.03,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
