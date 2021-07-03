import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../widgets/notification_detailed_widgets/custom_button.dart';
import '../widgets/products_widgets/product_image_list.dart';
import '../widgets/products_widgets/title_bookmark.dart';
import '../widgets/products_widgets/price_condition.dart';
import '../widgets/products_widgets/heading_content.dart';
import '../widgets/products_widgets/tags.dart';
import '../widgets/contact_card.dart';
import '../providers/appUser.dart';
import '../providers/productsData.dart';
import '../models/product.dart';
import '../widgets/sell_form_widgets/bottom_navigation_buttons.dart';
import '../widgets/sell_form_widgets/sell_screen_constants.dart';
import '../providers/appNotification.dart';
import './sell_screen_part1.dart';
import '../services/firebaseServices.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/ProductDetailScreen';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String newPrice;

  String message;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SnackBar _snackBar = SnackBar(
    elevation: 0,
    backgroundColor: const Color(0xff00C217),
    duration: Duration(seconds: 2),
    content: Text(
      'Offer Request Sent',
      textAlign: TextAlign.center,
    ),
  );

  dynamic openBottomModalSheet(MediaQueryData mediaQuery, BuildContext ctx,
      AppUser appUser, Product product) {
    newPrice = product.price;
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: const Color(0x00ffffff),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width * 0.05,
                mediaQuery.size.height * 0.06,
                mediaQuery.size.width * 0.05,
                mediaQuery.size.height * 0.04 +
                    MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Price
                    TextFormField(
                      initialValue: newPrice,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: inputDecoration.copyWith(
                        labelText: 'Your Price',
                      ),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Required';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        newPrice = value;
                      },
                    ),

                    SizedBox(
                      height: mediaQuery.size.height * 0.03,
                    ),
                    //I Used it for
                    TextFormField(
                      maxLines: 5,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Message',
                      ),
                      onChanged: (value) {
                        message = value;
                      },
                    ),

                    SizedBox(
                      height: mediaQuery.size.height * 0.03,
                    ),

                    CustomButton(
                      width: mediaQuery.size.width,
                      height: mediaQuery.size.height,
                      title: 'Post Request',
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Scaffold.of(ctx).showSnackBar(_snackBar);
                          AppNotification newAppNotification =
                              AppNotification();
                          newAppNotification.senderUid = appUser.uid;
                          newAppNotification.senderName = appUser.name;
                          newAppNotification.senderCollege = appUser.college;
                          newAppNotification.senderBranch = appUser.branch;
                          newAppNotification.senderSem = appUser.sem;
                          newAppNotification.senderPhone = appUser.phone;
                          newAppNotification.senderPictureUrl =
                              appUser.profilePhotoUrl;
                          newAppNotification.senderDeviceToken =
                              appUser.deviceToken;

                          newAppNotification.receiverUid = product.sellerUid;
                          newAppNotification.receiverDeviceToken =
                              product.sellerDeviceToken;

                          newAppNotification.productUid = product.uid;
                          newAppNotification.productTitle = product.title;
                          newAppNotification.productBranch = product.branch;
                          newAppNotification.productSem = product.sem;
                          newAppNotification.productOriginalPrice =
                              product.price;

                          newAppNotification.productOfferedPrice = newPrice;

                          newAppNotification.subject = newPrice != product.price
                              ? 'New Price Request'
                              : 'Ready To Buy';
                          newAppNotification.message = message;

                          newAppNotification.dateTime =
                              DateTime.now().toString();

                          FirebaseServices()
                              .uploadNotification(newAppNotification);

                          Navigator.of(context).pop();
                        }
                      },
                      type: 1,
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(mediaQuery.size.width * 0.03),
                  topRight: Radius.circular(mediaQuery.size.width * 0.03),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final String productUid =
        ModalRoute.of(context).settings.arguments as String;

    final AppUser appUserObject =
        Provider.of<AppUser>(context, listen: false).getAppUserObject;

    final Product product = Provider.of<ProductsData>(context, listen: false)
        .getProductByUid(productUid);

    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    if (product == null) {
      FirebaseServices().manageBookmark(context, product, productUid);
    }
    return product == null
        ? Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  'assets/icons/trash.svg',
                  height: width * 0.35,
                  color: const Color(0xffe8e8e8),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Text(
                  'This Product Is\nNo Longer Available',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xffa8a8a8),
                  ),
                )
              ],
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: Builder(
              builder: (ctx) {
                return BottomNavigationButtons(
                  deviceWidth: width,
                  button1Title: 'Share',
                  button1OnPresses: () async {
                    Share.share(
                        'https://play.google.com/store/apps/details?id=com.kumard.famflet\n\nHey, check out this product that I found on FamFlet. You might find it useful.');
                  },
                  button2Title: product.sellerUid == appUserObject.uid
                      ? 'Edit'
                      : 'Make An Offer',
                  button2OnPresses: () {
                    product.sellerUid == appUserObject.uid
                        ? Navigator.of(context).pushNamed(
                            SellScreenPart1.routeName,
                            arguments: product,
                          )
                        : openBottomModalSheet(
                            mediaQuery, ctx, appUserObject, product);
                  },
                );
              },
            ),
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
                        // Products image listview
                        ProductImageList(
                          width: width,
                          height: height,
                          imageList: product.pictureUrls,
                        ),

                        //title and heart button
                        TitleBookMark(
                          width: width,
                          height: height,
                          title: product.title,
                          delete: product.sellerUid == appUserObject.uid
                              ? true
                              : false,
                          product: product,
                        ),

                        //price and condition
                        PriceCondition(
                          width: width,
                          height: height,
                          price: product.price,
                          condition: product.condition,
                        ),

                        //Description
                        HeadingContent(
                          width: width,
                          height: height,
                          heading: 'Description',
                          content: product.description,
                        ),

                        //tags
                        product.category == 'Non Academics'
                            ? Container(
                                width: width,
                              )
                            : Tags(
                                width: width,
                                height: height,
                                branch: product.branch,
                                sem: product.sem,
                                subject: product.subject,
                              ),

                        //seller used it for
                        HeadingContent(
                          width: width,
                          height: height,
                          heading: 'Seller Used It For',
                          content: product.iUsedItFor,
                        ),

                        //seller
                        appUserObject.uid == product.sellerUid
                            ? Container(
                                width: width,
                              )
                            : ContactCard(
                                width: width,
                                height: height,
                                label: 'seller',
                                pictureUrl: product.sellerImage,
                                name: product.sellerName,
                                college: product.sellerCollege,
                                branch: product.sellerBranch,
                                sem: product.sellerSem,
                                phone: null,
                              ),

                        //extra space for floating buttons
                        SizedBox(
                          height: height * 0.03,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
