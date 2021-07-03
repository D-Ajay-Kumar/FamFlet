import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/firebaseServices.dart';

class DeleteAlert extends StatelessWidget {
  final BuildContext scaffoldKeyContext;
  final Product product;

  DeleteAlert(this.scaffoldKeyContext, this.product);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Do You Want To Delete This Product?'),
      actions: [
        //cancel button
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: const Color(0xFFd71f1f)),
          ),
        ),

        //delete
        TextButton(
          onPressed: () {
            FirebaseServices().deleteProduct(scaffoldKeyContext, product);
            Navigator.of(context).pop();
            Navigator.of(context).pop();

            // Navigator.of(context).pop();
          },
          child: Text(
            'Yes',
            style: TextStyle(color: const Color(0xFFd71f1f)),
          ),
        ),
      ],
    );
  }
}
