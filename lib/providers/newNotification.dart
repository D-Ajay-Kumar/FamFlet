import 'package:flutter/material.dart';

class NewNotification with ChangeNotifier {
  bool _newNotification;

  set setNewNotification(bool value) {
    _newNotification = value;
    notifyListeners();
  }

  bool get getNewNotification {
    return _newNotification;
  }
}
