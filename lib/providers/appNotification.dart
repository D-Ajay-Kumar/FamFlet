import 'package:flutter/foundation.dart';

class AppNotification with ChangeNotifier {
  String notificationUid;

  String senderUid;
  String senderName;
  String senderCollege;
  String senderBranch;
  String senderSem;
  String senderPhone;
  String senderPictureUrl;
  String senderDeviceToken;

  String receiverUid;
  String receiverDeviceToken;

  String productUid;
  String productTitle;
  String productBranch;
  String productSem;
  String productOriginalPrice;

  String productOfferedPrice;

  String subject;
  String response;
  String message;

  String dateTime;

  bool readStatus = false;
  bool isAnswered = false;

  Map<String, dynamic> toNotificationMap() {
    return {
      'notificationUid': notificationUid,
      'senderUid': senderUid,
      'senderName': senderName,
      'senderCollege': senderCollege,
      'senderBranch': senderBranch,
      'senderSem': senderSem,
      'senderPhone': senderPhone,
      'senderPictureUrl': senderPictureUrl,
      'senderDeviceToken': senderDeviceToken,
      'receiverDeviceToken': receiverDeviceToken,
      'receiverUid': receiverUid,
      'productUid': productUid,
      'productTitle': productTitle,
      'productBranch': productBranch,
      'productSem': productSem,
      'productOriginalPrice': productOriginalPrice,
      'productOfferedPrice': productOfferedPrice,
      'subject': subject,
      'message': message,
      'response': response,
      'dateTime': dateTime,
      'readStatus': readStatus,
      'isAnswered': isAnswered,
    };
  }

  void toNotificationObject(Map<String, dynamic> notificationMap) {
    this.notificationUid = notificationMap['notificationUid'];

    this.senderUid = notificationMap['senderUid'];
    this.senderName = notificationMap['senderName'];
    this.senderCollege = notificationMap['senderCollege'];
    this.senderBranch = notificationMap['senderBranch'];
    this.senderSem = notificationMap['senderSem'];
    this.senderPhone = notificationMap['senderPhone'];
    this.senderPictureUrl = notificationMap['senderPictureUrl'];
    this.senderDeviceToken = notificationMap['senderDeviceToken'];

    this.receiverDeviceToken = notificationMap['receiverDeviceToken'];
    this.receiverUid = notificationMap['receiverUid'];

    this.productUid = notificationMap['productUid'];
    this.productTitle = notificationMap['productTitle'];
    this.productBranch = notificationMap['productBranch'];
    this.productSem = notificationMap['productSem'];
    this.productOriginalPrice = notificationMap['productOriginalPrice'];
    this.productOfferedPrice = notificationMap['productOfferedPrice'];

    this.subject = notificationMap['subject'];
    this.message = notificationMap['message'];
    this.response = notificationMap['response'];

    this.dateTime = notificationMap['dateTime'];

    this.readStatus = notificationMap['readStatus'];
    this.isAnswered = notificationMap['isAnswered'];
  }

  void callNotifyListeners() {
    notifyListeners();
  }
}
