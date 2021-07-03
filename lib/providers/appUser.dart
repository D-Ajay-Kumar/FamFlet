import 'package:flutter/foundation.dart';

class AppUser with ChangeNotifier {
  String uid;
  String deviceToken;
  String email;
  String name;
  String college;
  String branch;
  String phone;
  String sem;
  String profilePhotoUrl;

  String dateTime;

  AppUser _appUserObject;

  Map<String, dynamic> toAppUserMap() {
    return {
      'uid': uid,
      'deviceToken': deviceToken,
      'email': email,
      'name': name,
      'college': college,
      'phone': phone,
      'branch': branch,
      'sem': sem,
      'profilePhotoUrl': profilePhotoUrl,
      'dateTime': dateTime,
    };
  }

  void toAppUserObject(Map<String, dynamic> data) {
    this.uid = data['uid'];
    this.deviceToken = data['deviceToken'];
    this.email = data['email'];
    this.name = data['name'];
    this.college = data['college'];
    this.phone = data['phone'];
    this.branch = data['branch'];
    this.sem = data['sem'];
    this.profilePhotoUrl = data['profilePhotoUrl'];
    this.dateTime = data['dateTime'];
  }

  set setAppUser(AppUser appUser) {
    _appUserObject = appUser;
    notifyListeners();
  }

  AppUser get getAppUserObject {
    return _appUserObject;
  }

  void removeData() {
    _appUserObject = null;
  }
}
