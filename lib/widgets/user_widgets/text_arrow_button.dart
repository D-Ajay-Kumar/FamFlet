import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import '../../screens/about_faq_policies.dart';

class TextAndArrowButton extends StatelessWidget {
  const TextAndArrowButton({
    @required this.width,
    @required this.height,
    @required this.title,
  });

  final double width;
  final double height;
  final String title;

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = height * 0.01;
    final double horizontalPadding = width * 0.05;

    return GestureDetector(
      onTap: () async {
        if (title == 'Feedback Form') {
          const String feedbackFormUrl = 'https://forms.gle/7XKRPvBGffkg8PuX9';
          if (await canLaunch(feedbackFormUrl)) {
            launch(feedbackFormUrl);
            return;
          } else {
            throw 'Cannot Launch';
          }
        } else if (title == 'Rate And Review FamFlet') {
          const String playstoreUrl =
              'https://play.google.com/store/apps/details?id=com.kumard.famflet';
          if (await canLaunch(playstoreUrl)) {
            launch(playstoreUrl);
            return;
          } else {
            throw 'Cannot Launch';
          }
        } else if (title == 'Share FamFlet') {
          Share.share(
              'https://play.google.com/store/apps/details?id=com.kumard.famflet\n\nHey, check out the FamFlet app.');
          return;
        }
        Navigator.pushNamed(context, AboutFaqPolicies.routeName,
            arguments: title);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(
            horizontalPadding, verticalPadding, horizontalPadding, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: const Color(0xffb8b8b8),
            ),
          ],
        ),
      ),
    );
  }
}
