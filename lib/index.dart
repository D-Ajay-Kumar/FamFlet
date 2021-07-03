import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './services/firebaseServices.dart';
import './providers/firebaseAppUser.dart';
import './screens/user_profile_screen.dart';
import './screens/notifications_screen.dart';
import './screens/search_screen.dart';
import './screens/home.dart';
import './providers/appUser.dart';
import './providers/newNotification.dart';
import './screens/sell_screen_part1.dart';
import './constants.dart';

class Index extends StatefulWidget {
  static const routeName = '/Index';
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> with WidgetsBindingObserver {
  FirebaseMessaging fcm;
  AppUser appUserObject;
  NewNotification newNotificationProvider;
  User appUser;
  SharedPreferences sharedPreferences;

  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();

    newNotificationProvider =
        Provider.of<NewNotification>(context, listen: false);

    appUserObject =
        Provider.of<AppUser>(context, listen: false).getAppUserObject;

    appUser =
        Provider.of<FirebaseAppUser>(context, listen: false).getFirebaseAppUser;

    fcm = FirebaseMessaging();

    fcm.onTokenRefresh.distinct().listen(
      (token) async {
        sharedPreferences = await SharedPreferences.getInstance();

        final String fcmToken = sharedPreferences.getString('fcmTokenKey');

        // if the app was run after reinstalling then shared preferences gets deleted
        // and a null value will be fetched against the key
        if (fcmToken.toString() == null) {
          sharedPreferences.setString('fcmTokenKey', token);
          FirebaseServices().uploadDeviceToken(context, appUser, token);
          FirebaseServices()
              .uploadRefreshedDeviceTokenOnProductsAndNotifications(
                  token, appUser, context);
        }
        // if the token gets changed somehow
        else if (token != fcmToken) {
          FirebaseServices().uploadDeviceToken(context, appUser, token);
          FirebaseServices()
              .uploadRefreshedDeviceTokenOnProductsAndNotifications(
                  token, appUser, context);
        }
      },
    );

    if (init == true) {
      // from constant file
      init = false;
      initialiseData();

      fcm.configure(
        onMessage: (msg) {
          FirebaseServices().downloadNewNotificationStatus(context);

          Future.delayed(Duration(seconds: 1)).then(
            (value) {
              if (newNotificationProvider.getNewNotification) {
                if (_selectedIndex == 3) {
                  newNotificationProvider.setNewNotification = false;
                  FirebaseServices()
                      .uploadNewNotificationStatus(context, false);
                } else {
                  // if the button is already red
                  if (!newNotificationProvider.getNewNotification) {
                    newNotificationProvider.setNewNotification = true;
                  }
                }
              }
              FirebaseServices().downloadNotifications(context);

              return;
            },
          );
        },
        onResume: (msg) {
          Navigator.of(context).popUntil(
            ModalRoute.withName(Index.routeName),
          );

          if (_selectedIndex != 3) {
            setState(() {
              _selectedIndex = 3;
            });
          }

          FirebaseServices().uploadNewNotificationStatus(context, false);

          FirebaseServices().downloadNotifications(context);

          return;
        },
        onLaunch: (msg) {
          setState(() {
            _selectedIndex = 3;
          });
          FirebaseServices().uploadNewNotificationStatus(context, false);

          return;
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await FirebaseServices().downloadNewNotificationStatus(context);

      if (newNotificationProvider.getNewNotification) {
        await FirebaseServices().downloadNotifications(context);
      } else {
        return;
      }

      if (_selectedIndex == 3) {
        FirebaseServices().uploadNewNotificationStatus(context, false);
      } else {
        return;
      }
    }
  }

  void navigateToNotifications() {
    setState(() {
      _selectedIndex = 3;
      // FocusScope.of(context).unfocus();
    });
  }

  Future<void> initialiseData() async {
    await FirebaseServices().downloadAppUser(context);
    await FirebaseServices().downloadProductsList(context);
    await FirebaseServices().downloadNotifications(context);
    await FirebaseServices().downloadUserProducts(context);
    await FirebaseServices().downloadInTalksProducts(context);
    await FirebaseServices().downloadBookmarks(context);
    await FirebaseServices().downloadNewNotificationStatus(context);
  }

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Home(),
    SearchScreen(),
    Container(),
    NotificationsScreen(),
    UserProfileScreen(),
  ];

  bool canback = false;

  // ignore: missing_return
  Future<bool> _onWillPop() async {
    if (canback == true) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else {
      setState(() {
        this._selectedIndex = 0;
      });
    }

    Timer(Duration(seconds: 2), () {
      setState(() {
        canback = false;
      });
    });
    canback = true;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, //fixing sell button after soft keyboard

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              SellScreenPart1.routeName,
              arguments: null,
            );
          },
          backgroundColor: const Color(0xff000000),
          elevation: 0,
          child: SvgPicture.asset(
            'assets/icons/plus.svg',
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 0.0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xffffffff),
          currentIndex: _selectedIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                color: this._selectedIndex == 0
                    ? const Color(0xff000000)
                    : const Color(0xffD8D8D8),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/search.svg',
                color: this._selectedIndex == 1
                    ? const Color(0xff000000)
                    : const Color(0xffD8D8D8),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/sell.svg',
                color: const Color(0xff000000),
              ),
              label: 'Sell',
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  setState(() {
                    FirebaseServices()
                        .uploadNewNotificationStatus(context, false);
                    _selectedIndex = 3;
                  });
                },
                child: Consumer<NewNotification>(
                  builder: (context, newNotification, child) {
                    final bool newNotificationsStatus =
                        newNotification.getNewNotification;
                    return (newNotificationsStatus == null
                            ? false
                            : newNotificationsStatus)
                        ? SvgPicture.asset('assets/icons/bell_red_dot.svg')
                        : SvgPicture.asset(
                            'assets/icons/bell.svg',
                            color: this._selectedIndex == 3
                                ? const Color(0xff000000)
                                : const Color(0xffD8D8D8),
                          );
                  },
                ),
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/user.svg',
                color: this._selectedIndex == 4
                    ? const Color(0xff000000)
                    : const Color(0xffD8D8D8),
              ),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            if (index == 2) {
              Navigator.of(context).pushNamed('/sell');
              return;
            }

            setState(() {
              this._selectedIndex = index;
            });
          },
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: (mediaQuery.size.height -
                AppBar().preferredSize.height -
                mediaQuery.padding.top),
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ), // this._screens[this._selectedIndex],
          ),
        ),
      ),
    );
  }
}
