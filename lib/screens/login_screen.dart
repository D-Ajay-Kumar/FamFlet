import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../services/googleServices.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double deviceHeight = mediaQuery.size.height - mediaQuery.padding.top;
    double deviceWidth = mediaQuery.size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: deviceHeight * 0.5,
              child: Swiper(
                pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    activeColor: const Color(0xff000000),
                    color: const Color(0xffe8e8e8),
                  ),
                ),
                autoplay: true,
                itemCount: svgs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: deviceHeight * 0.05,
                      horizontal: deviceWidth * 0.2,
                    ),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            svgs[index],
                            height: deviceHeight * 0.2,
                          ),
                          Text(
                            items[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: deviceHeight * 0.02,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ButtonTheme(
              height: deviceHeight * 0.06,
              minWidth: deviceWidth * 0.5,
              buttonColor: const Color(0xff000000),
              child: FlatButton.icon(
                color: const Color(0xFF000000),
                label: Text(
                  '   Bake. Buy. Sell.',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                icon: SvgPicture.asset(
                  'assets/vectors/google.svg',
                  height: deviceHeight * 0.03,
                ),
                onPressed: () {
                  GoogleServices().signInWithGoogle(context);
                },
                textColor: const Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
