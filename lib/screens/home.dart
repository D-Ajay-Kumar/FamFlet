import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/appUser.dart';
import '../services/firebaseServices.dart';
import '../widgets/name_bookmark.dart';
import '../widgets/day_greetings.dart';
import '../widgets/categories_seeall_products.dart';

class Home extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    return RefreshIndicator(
      onRefresh: () async {
        await FirebaseServices().downloadProductsList(context);
      },
      child: Container(
        height: height,
        width: width,
        child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
              return;
            },
            child: ListView(
              children: [
                //Text:Name and Saved Icon, User Consumer
                Consumer<AppUser>(
                  builder: (context, appUser, child) {
                    return NameBookmark(
                        height: height,
                        width: width,
                        name: appUser.getAppUserObject != null
                            ? appUser.getAppUserObject.name
                            : '');
                  },
                ),

                //day greetings
                DayGreetings(height: height, width: width),

                //categories and sell all, product consumer
                CategoriesAndSeeAllAndProducts(
                  height: height,
                  width: width,
                ),
              ],
            )),
      ),
    );
  }
}
