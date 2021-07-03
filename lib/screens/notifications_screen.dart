import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../widgets/notification_tile.dart';
import '../providers/appNotification.dart';
import '../providers/appNotificationsData.dart';
import '../services/firebaseServices.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  void changeColor(AppNotification appNotification) {
    if (appNotification.readStatus) {
      return;
    } else {
      setState(() {
        appNotification.readStatus = true;
      });
      FirebaseServices()
          .uploadUpdatedReadStatus(appNotification.notificationUid);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowGlow();
        return;
      },
      child: Consumer<AppNotificationsData>(
        builder: (context, appNotificationsData, child) {
          final List<AppNotification> notificationsList =
              appNotificationsData.getNotifications;
          return RefreshIndicator(
            child: Container(
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
              height: height,
              child: notificationsList == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : notificationsList.length == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/bell.svg',
                              height: width * 0.35,
                              color: const Color(0xffe8e8e8),
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            Text(
                              'No Notifications\nRight Now!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xffa8a8a8),
                              ),
                            )
                          ],
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return NotificationTile(
                              height,
                              width,
                              notificationsList[index],
                              index,
                              notificationsList.length,
                              changeColor,
                            );
                          },
                          itemCount: notificationsList.length,
                        ),
            ),
            onRefresh: () async {
              await FirebaseServices().downloadNotifications(context);
            },
          );
        },
      ),
    );
  }
}
