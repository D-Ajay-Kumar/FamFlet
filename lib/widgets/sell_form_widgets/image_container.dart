import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({
    Key key,
    @required this.deviceWidth,
    @required this.index,
    @required this.countImage,
    @required this.url,
  }) : super(key: key);

  final double deviceWidth;
  final int index;
  final Function countImage;
  final dynamic url;

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  dynamic _image;

  @override
  void initState() {
    super.initState();
    _image = widget.url;
  }

  final picker = ImagePicker();

  Future getImage(int flag) async {
    dynamic pickedFile = '';

    if (flag == 1) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      );
    } else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 10,
      );
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.countImage(widget.index, _image);
      }
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Pick One Source'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      getImage(1);
                    },
                    child: ListTile(
                      leading: Icon(Icons.filter),
                      title: Text('Gallery'),
                      subtitle: Divider(
                        color: const Color(0xffe8e8e8),
                        thickness: 1,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage(2);
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera_alt_outlined),
                      title: Text('Camera'),
                      subtitle: Divider(
                        color: const Color(0xffe8e8e8),
                        thickness: 1,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        height: (widget.deviceWidth * 0.84) / 3,
        width: (widget.deviceWidth * 0.837) / 3,
        decoration: BoxDecoration(
          color: const Color(0xffe8e8e8),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: _image != null
            ? _image.runtimeType == String
                ? Image.network(_image, fit: BoxFit.cover)
                : Image.file(
                    _image,
                    fit: BoxFit.cover,
                  )
            : Center(
                child: Icon(
                  Icons.add_a_photo_outlined,
                  color: const Color(0xff616161),
                ),
              ),
      ),
    );
  }
}
