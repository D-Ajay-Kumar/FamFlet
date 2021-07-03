import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/product.dart';
import '../../providers/appUser.dart';
import '../../providers/appNotification.dart';
import '../../services/firebaseServices.dart';
import '../../providers/userProductsData.dart';
import '../../providers/productsData.dart';
import '../../providers/inTalksProductsData.dart';

class ActionButtons extends StatefulWidget {
  const ActionButtons({
    Key key,
    @required this.height,
    @required this.width,
    @required this.appNotification,
  });

  final double height;
  final double width;
  final AppNotification appNotification;

  @override
  _ActionButtonsState createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  ProductsData productsData;
  UserProductsData userProductsData;
  InTalksProductsData inTalksProductsData;
  AppUser appUser;
  Product product;

  AppNotification appNotificationProvider;

  AppNotification appNotification;

  SnackBar _snackBar = SnackBar(
    duration: Duration(seconds: 2),
    elevation: 0,
    backgroundColor: const Color(0xff00C217),
    content: Text(
      'Notification Sent',
      textAlign: TextAlign.center,
    ),
  );

  @override
  initState() {
    super.initState();
    appNotificationProvider =
        Provider.of<AppNotification>(context, listen: false);

    productsData = Provider.of<ProductsData>(context, listen: false);
    userProductsData = Provider.of<UserProductsData>(context, listen: false);
    inTalksProductsData =
        Provider.of<InTalksProductsData>(context, listen: false);
    appUser = Provider.of<AppUser>(context, listen: false).getAppUserObject;

    appNotification = widget.appNotification;

    product = userProductsData.getProductByUid(appNotification.productUid) ??
        inTalksProductsData.getProductByUid(appNotification.productUid);
  }

  void onButtonPressed(String answer) {
    Scaffold.of(context).showSnackBar(_snackBar);
    appNotification.isAnswered = true;
    FirebaseServices()
        .uploadUpdatedAnsweredStatus(appNotification.notificationUid);

    AppNotification newAppNotification = AppNotification();
    newAppNotification.senderUid = appUser.uid;
    newAppNotification.senderName = appUser.name;
    newAppNotification.senderCollege = appUser.college;
    newAppNotification.senderBranch = appUser.branch;
    newAppNotification.senderSem = appUser.sem;
    newAppNotification.senderPhone = appUser.phone;
    newAppNotification.senderPictureUrl = appUser.profilePhotoUrl;
    newAppNotification.senderDeviceToken = appUser.deviceToken;

    newAppNotification.receiverUid = appNotification.senderUid;
    newAppNotification.receiverDeviceToken = appNotification.senderDeviceToken;

    newAppNotification.productUid = appNotification.productUid;
    newAppNotification.productTitle = appNotification.productTitle;
    newAppNotification.productBranch = appNotification.productBranch;
    newAppNotification.productSem = appNotification.productSem;
    newAppNotification.productOriginalPrice =
        appNotification.productOriginalPrice;

    newAppNotification.productOfferedPrice =
        appNotification.productOfferedPrice;

    newAppNotification.subject = 'Offer $answer';
    newAppNotification.message = null;

    newAppNotification.dateTime = DateTime.now().toString();

    if (answer == 'Accepted') {
      productsData.removeProduct(appNotification.productUid);
      userProductsData.removeProduct(appNotification.productUid);
      inTalksProductsData.addProduct(product);
      product.isAvailable = false;

      appNotification.response = 'Accepted';
      appNotificationProvider.callNotifyListeners();

      FirebaseServices().uploadNotificationResponse(
          context, appNotification.notificationUid, 'Accepted');
      FirebaseServices().uploadProductAvailability(
          navigatorKey.currentContext, product.uid, false);
    } else {
      appNotification.response = 'Declined';
      appNotificationProvider.callNotifyListeners();
      FirebaseServices().uploadNotificationResponse(
          context, appNotification.notificationUid, 'Declined');
    }

    FirebaseServices().uploadNotification(newAppNotification);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.height * 0.05, bottom: widget.height * 0.1),
      child: product == null
          ? Text(
              'This product has been\ndeleted',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: widget.height * 0.02,
              ),
            )
          : Wrap(
              spacing: widget.width * 0.05,
              children: [
                // Decline Button
                ButtonTheme(
                  height: widget.height * 0.06,
                  minWidth: widget.width * 0.35,
                  child: OutlineButton(
                    color: const Color(0xff000000),
                    borderSide: BorderSide(
                      color: const Color(0xff000000),
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                    onPressed: () {
                      onButtonPressed('Declined');
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      'Decline',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                ),

                // Accept Button
                ButtonTheme(
                  height: widget.height * 0.06,
                  minWidth: widget.width * 0.35,
                  child: FlatButton(
                    color: const Color(0xff000000),
                    onPressed: () {
                      onButtonPressed('Accepted');
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      'Accept',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
