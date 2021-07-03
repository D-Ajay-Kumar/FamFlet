import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/bookmark.dart';
import '../services/firebaseServices.dart';
import '../widgets/products_grid.dart';

class BookmarksScreen extends StatelessWidget {
  static const routeName = '/BookmarkScreen';

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await FirebaseServices().downloadBookmarks(context);
          },
          child: Container(
            height: height,
            width: width,
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowGlow();
                return true;
              },
              child: ListView(
                children: [
                  Container(
                    width: width,
                    padding: EdgeInsets.fromLTRB(
                        width * 0.05, height * 0.03, width * 0.05, 0),
                    child: Text(
                      'Bookmarks',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Consumer<Bookmark>(
                    builder: (context, bookmark, child) {
                      final List<Bookmark> bookmarksList =
                          bookmark.getBookmarks;
                      return bookmarksList == null
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : bookmarksList.length == 0
                              ? Container(
                                  height: height * 0.6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/bookmark.svg',
                                        height: width * 0.35,
                                        color: const Color(0xffe8e8e8),
                                      ),
                                      SizedBox(
                                        height: height * 0.05,
                                      ),
                                      Text(
                                        'No Bookmarks\nRight Now!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          // fontSize: height * 0.025,
                                          // fontWeight: FontWeight.w500,
                                          color: const Color(0xffa8a8a8),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : ProductsGrid(
                                  width: width,
                                  height: height,
                                  itemsList: bookmarksList,
                                );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
