import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/userProductsData.dart';
import '../providers/inTalksProductsData.dart';
import '../widgets/user_widgets/circular_avatar.dart';
import '../widgets/user_widgets/text_edit_button.dart';
import '../widgets/user_widgets/text_user_details.dart';
import '../widgets/user_widgets/text_see_all_button.dart';
import '../widgets/user_widgets/user_products.dart';
import '../widgets/user_widgets/text_arrow_button.dart';
import '../providers/appUser.dart';
import '../services/googleServices.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    return Container(
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
              Consumer<AppUser>(
                builder: (context, appUser, child) {
                  final AppUser appUserObject = appUser.getAppUserObject;
                  return appUserObject == null
                      ? Container(
                          width: width,
                        )
                      : Column(
                          children: [
                            CircularAvatar(
                              height: height,
                              width: width,
                              imageUrl: appUserObject.profilePhotoUrl,
                            ),

                            //profile text and edit button
                            child,

                            //User details
                            TextUserDetails(
                                width: width,
                                height: height,
                                attribute: 'Name',
                                info: appUserObject.name),
                            TextUserDetails(
                                width: width,
                                height: height,
                                attribute: 'Email',
                                info: appUserObject.email),
                            TextUserDetails(
                                width: width,
                                height: height,
                                attribute: 'Phone No',
                                info: appUserObject.phone),
                            TextUserDetails(
                                width: width,
                                height: height,
                                attribute: 'College',
                                info: appUserObject.college),
                            TextUserDetails(
                                width: width,
                                height: height,
                                attribute: 'Branch',
                                info: appUserObject.branch),
                            TextUserDetails(
                                width: width,
                                height: height,
                                attribute: 'Semester',
                                info: appUserObject.sem),
                          ],
                        );
                },
                child: TextAndEditButton(
                  height: height,
                  width: width,
                  title: 'Profile',
                ),
              ),
              //User profile pic

              Consumer<UserProductsData>(
                builder: (context, userProductsData, child) {
                  final List<Product> userProductsList =
                      userProductsData.getUserProducts;
                  return userProductsList == null
                      ? Container(
                          width: width,
                        )
                      : userProductsList.isNotEmpty
                          ? Column(
                              children: [
                                //on sale and see all
                                child,
                                //on sale products
                                UserProducts(
                                  width: width,
                                  height: height,
                                  productsList: userProductsList,
                                ),
                              ],
                            )
                          : Container(
                              width: width,
                            );
                },
                child: TextAndSeeAllButton(
                  height: height,
                  width: width,
                  heading: 'On Sale',
                ),
              ),

              Consumer<InTalksProductsData>(
                builder: (context, inTalksProductsData, child) {
                  final List<Product> inTalksList =
                      inTalksProductsData.getInTalksProducts;
                  return inTalksList == null
                      ? Container(
                          width: width,
                        )
                      : inTalksList.isNotEmpty
                          ? Column(
                              children: [
                                //in talks and see all
                                child,
                                //in talks products
                                Opacity(
                                  opacity: 0.5,
                                  child: UserProducts(
                                      width: width,
                                      height: height,
                                      productsList: inTalksList),
                                ),
                              ],
                            )
                          : Container(
                              width: width,
                            );
                },
                child: TextAndSeeAllButton(
                  height: height,
                  width: width,
                  heading: 'In Talks',
                ),
              ),

              //support
              Container(
                padding: EdgeInsets.fromLTRB(
                    width * 0.05, height * 0.04, width * 0.05, 0),
                width: width,
                child: Text(
                  'Support',
                  style: TextStyle(
                    fontSize: height * 0.02,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              //about app
              TextAndArrowButton(
                height: height,
                width: width,
                title: 'About FamFlet',
              ),
              TextAndArrowButton(
                height: height,
                width: width,
                title: 'FamFlet FAQs',
              ),
              TextAndArrowButton(
                height: height,
                width: width,
                title: 'Policies',
              ),

              TextAndArrowButton(
                height: height,
                width: width,
                title: 'Feedback Form',
              ),
              TextAndArrowButton(
                height: height,
                width: width,
                title: 'Share FamFlet',
              ),
              TextAndArrowButton(
                height: height,
                width: width,
                title: 'Rate And Review FamFlet',
              ),

              //signout
              GestureDetector(
                onTap: () {
                  GoogleServices().logOutCurrentUser(context);
                },
                child: Container(
                  padding: EdgeInsets.only(top: height * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: const Color(0xFFd71f1f),
                      ),
                      Text(
                        '  Sign Out',
                        style: TextStyle(
                          color: const Color(0xFFd71f1f),
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //version
              Container(
                padding:
                    EdgeInsets.only(top: height * 0.01, bottom: height * 0.1),
                child: Text(
                  'FamFlet 1.0.0+2',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
