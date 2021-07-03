import 'package:flutter/material.dart';

import '../models/product.dart';

class InTalksProductsData with ChangeNotifier {
  List<Product> _inTalksProducts = [];

  set setInTalksProducts(List<Product> inTalksProducts) {
    _inTalksProducts = inTalksProducts;
    notifyListeners();
  }

  void addProduct(Product newProduct) {
    if (_inTalksProducts.any((product) => product.uid == newProduct.uid)) {
      return;
    }
    _inTalksProducts.insert(0, newProduct);
    notifyListeners();
  }

  void removeProduct(String productUid) {
    _inTalksProducts.removeWhere((product) => product.uid == productUid);
    notifyListeners();
  }

  List<Product> get getInTalksProducts {
    return [..._inTalksProducts];
  }

  Product getProductByUid(String uid) {
    return _inTalksProducts.firstWhere(
      (prod) => prod.uid == uid,
      orElse: () => null,
    );
  }
}
