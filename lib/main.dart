import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'providers/appNotification.dart';
import './screens/about_faq_policies.dart';
import './screens/bookmarks_screen.dart';
import './screens/sell_screen_part1.dart';
import './screens/sell_screen_part2.dart';
import 'screens/loading_screen.dart';
import './providers/firebaseAppUser.dart';
import './providers/appUser.dart';
import './providers/productsData.dart';
import './screens/product_detail_screen.dart';
import './screens/login_screen.dart';
import './providers/bookmark.dart';
import './providers/searchResults.dart';
import './providers/appNotificationsData.dart';
import './screens/notification_detail_screen.dart';
import './providers/userProductsData.dart';
import './providers/inTalksProductsData.dart';
import './screens/user_registration_screen.dart';
import './screens/open_image.dart';
import './index.dart';
import './providers/newNotification.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // to fix orientation to portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FirebaseAppUser(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppUser(),
        ),
        ChangeNotifierProvider.value(
          value: ProductsData(),
        ),
        ChangeNotifierProvider.value(
          value: Bookmark(),
        ),
        ChangeNotifierProvider.value(
          value: SearchResults(),
        ),
        ChangeNotifierProvider.value(
          value: AppNotificationsData(),
        ),
        ChangeNotifierProvider.value(
          value: UserProductsData(),
        ),
        ChangeNotifierProvider.value(
          value: InTalksProductsData(),
        ),
        ChangeNotifierProvider(
          create: (context) => NewNotification(),
        ),
        ChangeNotifierProvider.value(
          value: AppNotification(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData.light().copyWith(accentColor: Colors.black),
        debugShowCheckedModeBanner: false,
        home: LoadingScreen(),
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          NotificationDetailScreen.routeName: (context) =>
              NotificationDetailScreen(),
          UserRegistrationScreen.routeName: (context) =>
              UserRegistrationScreen(),
          Index.routeName: (context) => Index(),
          SellScreenPart1.routeName: (context) => SellScreenPart1(),
          SellScreenPart2.routeName: (context) => SellScreenPart2(),
          OpenImage.routeName: (context) => OpenImage(),
          BookmarksScreen.routeName: (context) => BookmarksScreen(),
          AboutFaqPolicies.routeName: (context) => AboutFaqPolicies(),
        },
      ),
    );
  }
}
