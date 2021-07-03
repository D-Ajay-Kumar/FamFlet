import 'package:flutter/foundation.dart';

import '../models/product.dart';

class SearchResults with ChangeNotifier {
  List<Product> _searchList = [];

  set setSearchList(List<Product> searchList) {
    _searchList = searchList;
    notifyListeners();
  }

  get getSearchList {
    return _searchList;
  }
}
