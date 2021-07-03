import 'package:flutter/material.dart';

import '../models/product.dart';

class UserProductsData with ChangeNotifier {
  List<Product> _userProducts = [];

  set setUserProducts(List<Product> userProducts) {
    _userProducts = userProducts;
    notifyListeners();
  }

  Product getProductByUid(String uid) {
    return _userProducts.firstWhere((prod) => prod.uid == uid,
        orElse: () => null);
  }

  void addProduct(Product newProduct, String status) {
    if (status == 'Edited') {
      _userProducts.removeWhere((prod) => prod.uid == newProduct.uid);
    }
    _userProducts.insert(0, newProduct);
    notifyListeners();
  }

  void removeProduct(String productUid) {
    _userProducts.removeWhere((product) => product.uid == productUid);
    notifyListeners();
  }

  List<Product> get getUserProducts {
    return [..._userProducts];
  }
}
