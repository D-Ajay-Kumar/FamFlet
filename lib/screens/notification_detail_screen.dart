import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/user_widgets/text_user_details.dart';
import '../widgets/products_widgets/heading_content.dart';
import '../widgets/notification_detailed_widgets/action_buttons.dart';
import '../providers/appNotification.dart';
import '../widgets/contact_card.dart';

class NotificationDetailScreen extends StatefulWidget {
  static const routeName = '/NotificationDetailScreen';

  @override
  _NotificationDetailScreenState createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final AppNotification appNotification =
        ModalRoute.of(context).settings.arguments as AppNotification;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    return appNotification == null
        ? Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  'assets/icons/trash.svg',
                  height: width * 0.35,
                  color: const Color(0xffe8e8e8),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Text(
                  'This Notification Is\nNo Longer Available',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xffa8a8a8),
                  ),
                )
              ],
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: Container(
                height: height,
                width: width,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //subject: subject title
                        Container(
                          width: width,
                          padding: EdgeInsets.fromLTRB(
                              width * 0.05, height * 0.04, width * 0.05, 0),
                          child: Text(
                            'Subject: ${appNotification.subject}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: height * 0.02,
                            ),
                          ),
                        ),

                        //sender contact box
                        ContactCard(
                          width: width,
                          height: height,
                          label: 'Sender',
                          pictureUrl: appNotification.senderPictureUrl,
                          name: appNotification.senderName,
                          college: appNotification.senderCollege,
                          branch: appNotification.senderBranch,
                          sem: appNotification.senderSem,
                          phone: appNotification.subject == "Offer Accepted"
                              ? appNotification.senderPhone
                              : null,
                        ),

                        //heading: product and content: product detail
                        HeadingContent(
                          width: width,
                          height: height,
                          heading: 'Product',
                          content: appNotification.productBranch == null
                              ? '${appNotification.productTitle}'
                              : '${appNotification.productTitle} \n\nBranch: ${appNotification.productBranch}, Sem: ${appNotification.productSem}',
                        ),

                        //original price
                        TextUserDetails(
                            width: width,
                            height: height,
                            attribute: 'Original Price',
                            info: '₹ ${appNotification.productOriginalPrice}'),

                        //price offered
                        TextUserDetails(
                            width: width,
                            height: height,
                            attribute: 'Offered Price',
                            info: '₹ ${appNotification.productOfferedPrice}'),

                        appNotification.subject == 'New Price Request' ||
                                appNotification.subject == 'Ready To Buy'
                            ?
                            //heading: Message
                            Column(
                                children: [
                                  Container(
                                    width: width,
                                    padding: EdgeInsets.fromLTRB(width * 0.05,
                                        height * 0.04, width * 0.05, 0),
                                    child: Text(
                                      'Message',
                                      style: TextStyle(
                                          //fontWeight: FontWeight.w300,
                                          ),
                                    ),
                                  ),

                                  //user typed and static app message
                                  Container(
                                    width: width,
                                    padding: EdgeInsets.fromLTRB(width * 0.05,
                                        height * 0.01, width * 0.05, 0),
                                    child: appNotification.message == null
                                        ? Text(
                                            'Hi! I\'m very much intrested in your product\n\nWould you like to accept my buy request?\nRegards!',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                            ),
                                          )
                                        : Text(
                                            '${appNotification.message}\n\nHi! I\'m very much intrested in your product\n\nWould you like to accept my buy request?\nRegards!',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                  ),
                                ],
                              )
                            : Container(
                                width: width,
                              ),

                        //date
                        Container(
                          width: width,
                          padding: EdgeInsets.fromLTRB(
                              width * 0.05, height * 0.05, width * 0.05, 0),
                          child: Text(
                            DateFormat('hh:mm a,   dd-MMM-yyyy').format(
                                DateTime.parse(appNotification.dateTime)),
                            //appNotification.dateTime, // .substring(0, 19),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),

                        Consumer<AppNotification>(
                          builder: (context, appNotif, child) {
                            return Column(
                              children: [
                                //buttons
                                (appNotification.subject ==
                                                'New Price Request' ||
                                            appNotification.subject ==
                                                'Ready To Buy') &&
                                        !appNotification.isAnswered
                                    ? ActionButtons(
                                        height: height,
                                        width: width,
                                        appNotification: appNotification,
                                      )
                                    : Container(
                                        width: width,
                                      ),

                                //response
                                appNotification.subject == 'Offer Declined' ||
                                        appNotification.subject ==
                                            'Offer Accepted'
                                    ? Container(
                                        width: width,
                                        padding: EdgeInsets.fromLTRB(
                                            width * 0.05,
                                            height * 0.04,
                                            width * 0.05,
                                            height * 0.01),
                                        child: Text(
                                          ((() {
                                            if (appNotification.subject ==
                                                'Offer Accepted') {
                                              return 'Seller Has Accepted Your Offer\nContact Him for Place And Time';
                                            } else {
                                              return 'Seller Has Declined Your Offer';
                                            }
                                          }())),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: height * 0.02,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: width,
                                        padding: EdgeInsets.fromLTRB(
                                          width * 0.05,
                                          height * 0.04,
                                          width * 0.05,
                                          height * 0.01,
                                        ),
                                        child: Text(
                                          appNotification.isAnswered == false
                                              ? ''
                                              : 'You ${appNotification.response} the Offer',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: height * 0.02,
                                          ),
                                        ),
                                      ),
                              ],
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
