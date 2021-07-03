import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/appNotification.dart';
import '../screens/notification_detail_screen.dart';
import '../screens/open_image.dart';

class NotificationTile extends StatelessWidget {
  final double height;
  final double width;
  final AppNotification appNotification;
  final int index;
  final int notificationsListLength;
  final Function changeColor;

  NotificationTile(this.height, this.width, this.appNotification, this.index,
      this.notificationsListLength, this.changeColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: index != notificationsListLength - 1
          ? EdgeInsets.only(top: height * 0.03)
          : EdgeInsets.only(top: height * 0.03, bottom: height * 0.1),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              changeColor(appNotification);

              Navigator.of(context).pushNamed(
                NotificationDetailScreen.routeName,
                arguments: appNotification,
              );
            },
            child: Container(
              height: width * 0.2,
              width: width * 0.9,
              decoration: BoxDecoration(
                color: appNotification.readStatus
                    ? null
                    : const Color(0xffe8e8e8), //only for unread msgs
                border: Border.all(
                  color: const Color(0xffe8e8e8),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(200.0),
                  bottomLeft: Radius.circular(200.0),
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(left: width * 0.23, right: width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      appNotification.senderName,
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Subject: ${appNotification.subject}',
                      style: TextStyle(
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        DateFormat('hh:mm a,   dd-MM-yy')
                            .format(DateTime.parse(appNotification.dateTime)),
                        style: TextStyle(
                          fontSize: width * 0.025,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: appNotification.senderPictureUrl != null
                ? () {
                    Navigator.of(context).pushNamed(OpenImage.routeName,
                        arguments: appNotification.senderPictureUrl);
                  }
                : () {},
            child: CircleAvatar(
              backgroundColor: const Color(0xffD8D8D8),
              radius: width * 0.1,
              backgroundImage: appNotification.senderPictureUrl != null
                  ? NetworkImage(
                      appNotification.senderPictureUrl,
                    )
                  : AssetImage(
                      'assets/images/defaultImage.png',
                    ),
            ),
          )
        ],
      ),
    );
  }
}
