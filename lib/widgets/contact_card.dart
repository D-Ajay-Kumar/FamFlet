import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../screens/open_image.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    @required this.width,
    @required this.height,
    @required this.label,
    @required this.pictureUrl,
    @required this.name,
    @required this.college,
    @required this.branch,
    @required this.sem,
    @required this.phone,
  });
  final double width;
  final double height;

  final String label;
  final String pictureUrl;
  final String name;
  final String college;
  final String branch;
  final String sem;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = height * 0.04;
    final double horizontalPadding = width * 0.05;

    return Container(
      padding: EdgeInsets.fromLTRB(
          horizontalPadding, verticalPadding, horizontalPadding, 0),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.01),
            padding: EdgeInsets.only(top: height * 0.01, bottom: height * 0.01),
            decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xffD8D8D8),
                ),
                borderRadius: BorderRadius.circular(5.0)),
            child: ListTile(
              leading: GestureDetector(
                onTap: pictureUrl != null
                    ? () {
                        Navigator.of(context).pushNamed(OpenImage.routeName,
                            arguments: pictureUrl);
                      }
                    : () {},
                child: CircleAvatar(
                  backgroundColor: const Color(0xffD8D8D8),
                  radius: height * 0.035,
                  backgroundImage: pictureUrl != null
                      ? NetworkImage(
                          pictureUrl,
                        )
                      : AssetImage('assets/images/defaultImage.png'),
                ),
              ),
              title: Text(name),
              subtitle: Text('$college, $branch, Sem: $sem'),
              trailing: phone == null
                  ? Icon(
                      Icons.phone,
                      color: Colors.white,
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.phone,
                      ),
                      onPressed: () async {
                        if (await canLaunch("tel:$phone")) {
                          launch("tel:$phone");
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Unable To Call Right Now!"),
                          ));
                        }
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
