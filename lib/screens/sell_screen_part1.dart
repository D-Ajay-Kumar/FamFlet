import 'package:flutter/material.dart';

import './sell_screen_part2.dart';
import '../widgets/sell_form_widgets/sell_screen_constants.dart';
import '../widgets/sell_form_widgets/image_container.dart';
import '../widgets/sell_form_widgets/bottom_navigation_buttons.dart';
import '../models/product.dart';

class SellScreenPart1 extends StatefulWidget {
  static const routeName = '/SellScreenPart1';
  @override
  _SellScreenPart1State createState() => _SellScreenPart1State();
}

class _SellScreenPart1State extends State<SellScreenPart1> {
  final _formKey = GlobalKey<FormState>();

  Product newProduct = Product();

  List<String> imageIndex = ['1', '2', '3', '4', '5'];
  List<int> imageNo = [0, 0, 0, 0, 0];
  List<dynamic> imageUrls = [null, null, null, null, null];

  bool imageError = false;

  bool flag = true;

  void countImages(int index, dynamic url) {
    imageNo[index] = 1;
    imageUrls[index] = url;
  }

  bool checkImages() {
    if (imageNo.reduce((a, b) => a + b) >= 2) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    final Product currProduct =
        ModalRoute.of(context).settings.arguments as Product;

    if (currProduct != null && flag) {
      for (int i = 0; i < currProduct.pictureUrls.length; i++) {
        countImages(i, currProduct.pictureUrls[i]);
      }

      // so that this function that set's current products pictures in the picture boxes
      // doesn't run again and reset any new pictures added
      flag = false;
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationButtons(
        deviceWidth: width,
        button1Title: 'Cancel',
        button1OnPresses: () {
          Navigator.of(context).pop();
        },
        button2Title: 'Next',
        button2OnPresses: () async {
          FocusScope.of(context).requestFocus(FocusNode());

          if (_formKey.currentState.validate() && checkImages()) {
            newProduct.category = newProduct.category ?? currProduct.category;
            newProduct.title = newProduct.title ?? currProduct.title;
            newProduct.description =
                newProduct.description ?? currProduct.description;

            if (currProduct != null) {
              newProduct.subject = currProduct.subject;
              newProduct.sem = currProduct.sem;
              newProduct.condition = currProduct.condition;
              newProduct.branch = currProduct.branch;
              newProduct.iUsedItFor = currProduct.iUsedItFor;
              newProduct.price = currProduct.price;
              newProduct.uid = currProduct.uid;
            }

            newProduct.pictureUrls =
                imageUrls.where((element) => element != null).toList();

            await Navigator.of(context).pushNamed(
              SellScreenPart2.routeName,
              arguments: newProduct,
            );
          }

          if (!checkImages()) {
            setState(() {
              imageError = true;
            });
          } else {
            setState(() {
              imageError = false;
            });
          }
        },
      ),
      body: SafeArea(
        child: Container(
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
                    //category
                    DropdownButtonFormField(
                      decoration: inputDecoration.copyWith(
                        labelText: 'Category',
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Required';
                        }
                        return null;
                      },
                      elevation: 24,
                      icon: Icon(Icons.arrow_drop_down_rounded),
                      value: currProduct != null
                          ? currProduct.category
                          : newProduct.category,
                      onChanged: (String newValue) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          newProduct.category = newValue;
                        });
                      },
                      items: category.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),

                    SizedBox(
                      height: height * 0.03,
                    ),
                    //Title
                    TextFormField(
                      initialValue:
                          currProduct != null ? currProduct.title : null,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        newProduct.title = value.trim();
                      },
                    ),

                    SizedBox(
                      height: height * 0.03,
                    ),
                    //Description
                    TextFormField(
                      initialValue:
                          currProduct != null ? currProduct.description : null,
                      autofocus: false,
                      maxLines: 7,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        newProduct.description = value.trim();
                      },
                    ),

                    SizedBox(
                      height: height * 0.03,
                    ),

                    //images
                    Container(
                      width: width,
                      child: Text(
                        'Upload Atleast 2 Images',
                        style: TextStyle(
                          color: imageError
                              ? const Color(0xFFd71f1f)
                              : const Color(0xFF757575),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: height * 0.01,
                    ),
                    Wrap(
                      runSpacing: width * 0.03,
                      spacing: width * 0.03,
                      children: imageIndex.map((e) {
                        return ImageContainer(
                          deviceWidth: width,
                          index: imageIndex.indexOf(e),
                          countImage: countImages,
                          url: imageUrls[imageIndex.indexOf(e)],
                        );
                      }).toList(),
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
