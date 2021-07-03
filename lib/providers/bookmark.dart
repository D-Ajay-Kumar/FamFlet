import 'package:flutter/cupertino.dart';

import '../models/product.dart';

class Bookmark with ChangeNotifier {
  String appUserUid;
  String uid; // uid of the product which is bookmarked
  String category;
  String title;
  String price;
  List pictureUrls;

  String branch;
  String sem;
  bool isAvailable;

  Bookmark(
      {this.appUserUid,
      this.uid,
      this.category,
      this.title,
      this.price,
      this.pictureUrls,
      this.branch,
      this.sem,
      this.isAvailable});

  Map<String, dynamic> toBookmarkMap() {
    return {
      'appUserUid': appUserUid,
      'uid': uid,
      'category': category,
      'title': title,
      'price': price,
      'pictureUrls': pictureUrls,
      'branch': branch,
      'sem': sem,
      'isAvailable': isAvailable
    };
  }

  void toBookmarkFromMap(Map<String, dynamic> bookmarkMap) {
    this.appUserUid = bookmarkMap['appUserUid'];
    this.uid = bookmarkMap['uid'];
    this.category = bookmarkMap['category'];
    this.title = bookmarkMap['title'];
    this.price = bookmarkMap['price'];
    this.pictureUrls = bookmarkMap['pictureUrls'];
    this.branch = bookmarkMap['branch'];
    this.sem = bookmarkMap['sem'];
    this.isAvailable = bookmarkMap['isAvailable'];
  }

  void toBookmarkFromProduct(Product product) {
    this.uid = product.uid;
    this.category = product.category;
    this.title = product.title;
    this.price = product.price;
    this.pictureUrls = [product.pictureUrls[0]];
    this.branch = product.branch;
    this.sem = product.sem;
    this.isAvailable = product.isAvailable;
  }

  List<Bookmark> _bookmarks = [];

  set setBookmarks(List<Bookmark> bookmarks) {
    _bookmarks = bookmarks;
    notifyListeners();
  }

  List<Bookmark> get getBookmarks {
    return _bookmarks;
  }

  void addBookmark(Bookmark bookmark) {
    _bookmarks.insert(0, bookmark);
    notifyListeners();
  }

  void removeBookmark(String bookmarkUid) {
    _bookmarks.removeWhere((product) => product.uid == bookmarkUid);
    notifyListeners();
  }
}
