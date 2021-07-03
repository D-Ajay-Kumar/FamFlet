import 'package:flutter/foundation.dart';

import 'appNotification.dart';

class AppNotificationsData with ChangeNotifier {
  List<AppNotification> _notificationsList;

  set setNotifications(List<AppNotification> notifications) {
    _notificationsList = notifications;
    notifyListeners();
  }

  List<AppNotification> get getNotifications {
    return _notificationsList;
  }

  void addNotification(AppNotification notification) {
    _notificationsList.insert(0, notification);
    notifyListeners();
  }

  AppNotification getNotificationByUid(String uid) {
    return _notificationsList
        .firstWhere((notification) => notification.notificationUid == uid);
  }

  void removeNotification(String uid) {
    _notificationsList.removeWhere((notification) =>
        notification.notificationUid == uid || notification.productUid == uid);
    notifyListeners();
  }

  void removeData() {
    _notificationsList = null;
  }
}
