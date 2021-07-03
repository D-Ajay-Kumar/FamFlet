import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/product.dart';
import '../../services/firebaseServices.dart';
import '../../widgets/delete_alert.dart';
import '../../providers/bookmark.dart';

class TitleBookMark extends StatelessWidget {
  const TitleBookMark({
    @required this.width,
    @required this.height,
    @required this.title,
    @required this.delete,
    @required this.product,
  });

  final double width;
  final double height;
  final String title;
  final bool delete;
  final Product product;

  @override
  Widget build(BuildContext context) {
    final List<Bookmark> bookmarksList =
        Provider.of<Bookmark>(context, listen: false).getBookmarks;

    final double verticalPadding = height * 0.03;
    final double horizontalPadding = width * 0.05;
    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        horizontalPadding * 0.6,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: width * 0.1),
            child: Align(
              alignment: Alignment.centerRight,
              child: delete
                  ? IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/trash.svg',
                      ),
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteAlert(
                                navigatorKey.currentContext,
                                product,
                              );
                            });

                        //Navigator.pop(context);
                      },
                    )
                  : Consumer<Bookmark>(
                      builder: (context, bookmark, child) {
                        return IconButton(
                          icon: bookmarksList
                                  .any((element) => element.uid == product.uid)
                              ? SvgPicture.asset(
                                  'assets/icons/bookmark_filled.svg',
                                )
                              : SvgPicture.asset('assets/icons/bookmark.svg'),
                          onPressed: () {
                            FirebaseServices()
                                .manageBookmark(context, product, product.uid);
                          },
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }
}
