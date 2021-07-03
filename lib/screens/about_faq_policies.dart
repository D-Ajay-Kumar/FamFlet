import 'package:flutter/material.dart';

import '../services/firebaseServices.dart';
import '../widgets/products_widgets/heading_content.dart';

class AboutFaqPolicies extends StatelessWidget {
  static const routeName = '/AboutFaqPolicies';

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    String title = ModalRoute.of(context).settings.arguments as String;

    String content = title == 'About FamFlet'
        ? 'about'
        : title == 'FamFlet FAQs'
            ? 'faqs'
            : 'policies';

    return Scaffold(
        body: SafeArea(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: height * 0.05),
          child: Container(
            child: FutureBuilder(
                future: FirebaseServices().downloadSupportData(context),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return HeadingContent(
                      content: snapshot.data.docs.first[content]
                          .toString()
                          .replaceAll("\\n", "\n"),
                      heading: title,
                      height: height,
                      width: width,
                    );
                  } else {
                    return Container(
                      height: height,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    ));
  }
}
