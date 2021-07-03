import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';

//  photo_view: ^0.10.2

class OpenImage extends StatelessWidget {
  static const String routeName = 'openImage';

  @override
  Widget build(BuildContext context) {
    final String imageUrl = ModalRoute.of(context).settings.arguments as String;
    return Container(
      child: PhotoView(
        minScale: PhotoViewComputedScale.contained,
        maxScale: 3.0,
        imageProvider: NetworkImage(
          '$imageUrl',
        ),
      ),
    );
  }
}
