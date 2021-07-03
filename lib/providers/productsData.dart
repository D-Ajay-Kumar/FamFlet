import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductsData with ChangeNotifier {
  // stores and provides all the products
  List<Product> _productsList = [];

  set setProductsList(List<Product> productsList) {
    _productsList = productsList;
    notifyListeners();
  }

  List<Product> get getProductsList {
    return [..._productsList];
  }

  Product getProductByUid(String uid) {
    return _productsList.firstWhere((prod) => prod.uid == uid,
        orElse: () => null);
  }

  void addProduct(Product newProduct, String status) {
    if (status == 'Edited') {
      _productsList.removeWhere((prod) => prod.uid == newProduct.uid);
    }

    _productsList.insert(0, newProduct);
    notifyListeners();
  }

  void removeProduct(String productUid) {
    _productsList.removeWhere((product) => product.uid == productUid);
    notifyListeners();
  }

  List<Product> get getAcademicsProduct {
    return [
      ..._productsList.where((element) {
        if (element.category == 'Academics')
          return true;
        else
          return false;
      })
    ];
  }

  List<Product> get getNonAcademicsProduct {
    return [
      ..._productsList.where((element) {
        if (element.category == 'Non Academics')
          return true;
        else
          return false;
      })
    ];
  }
}
