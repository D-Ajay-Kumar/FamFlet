import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../index.dart';
import '../providers/appUser.dart';
import '../providers/firebaseAppUser.dart';
import '../services/firebaseServices.dart';
import '../widgets/sell_form_widgets/sell_screen_constants.dart';

class UserRegistrationScreen extends StatefulWidget {
  static const routeName = '/UserRegistrationScreen';
  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  File _image;
  final picker = ImagePicker();

  Future getImage(int flag) async {
    dynamic pickedFile = '';

    if (flag == 1) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      );
    } else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 10,
      );
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });

    Navigator.of(context).pop();
  }

  AppUser _newAppUser = AppUser();

  String _nameInput;
  String _phoneInput;
  String _collegeInput;
  String _initialBranch;
  String _initialSem;
  final _formKey = GlobalKey<FormState>();

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    final AppUser appUser =
        Provider.of<AppUser>(context, listen: false).getAppUserObject ?? null;
    final User firebaseAppUser =
        Provider.of<FirebaseAppUser>(context, listen: false).getFirebaseAppUser;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    return Scaffold(
      body: SafeArea(
        child: isUploading
            ? Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                ),
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Center(
                      child: Text(
                        quotes[Random().nextInt(quotes.length)],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            : NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return true;
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: height * 0.03),
                  child: Container(
                    width: width,
                    padding:
                        EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
                    child: Center(
                      child: Column(children: [
                        //user profile
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Pick One Source'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          getImage(1);
                                        },
                                        child: ListTile(
                                          leading: Icon(Icons.filter),
                                          title: Text('Gallery'),
                                          subtitle: Divider(
                                            color: const Color(0xffe8e8e8),
                                            thickness: 1,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          getImage(2);
                                        },
                                        child: ListTile(
                                          leading:
                                              Icon(Icons.camera_alt_outlined),
                                          title: Text('Camera'),
                                          subtitle: Divider(
                                            color: const Color(0xffe8e8e8),
                                            thickness: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: height * 0.14,
                            width: height * 0.14,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xffe8e8e8),
                                  backgroundImage: appUser != null &&
                                          _image == null
                                      ? (appUser.profilePhotoUrl != null
                                          ? NetworkImage(
                                              appUser.profilePhotoUrl,
                                            )
                                          : AssetImage(
                                              'assets/images/defaultImage.png'))
                                      : (_image != null
                                          ? FileImage(_image)
                                          : AssetImage(
                                              'assets/images/defaultImage.png')),
                                  radius: height * 0.07,
                                ),
                                CircleAvatar(
                                  backgroundColor: const Color(0x50000000),
                                  radius: height * 0.07,
                                ),
                                Center(
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    size: height * 0.04,
                                    color: const Color(0xffffffff),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: height * 0.05,
                        ),
                        //TextFrom Fields
                        Form(
                          key: this._formKey,
                          child: Column(
                            children: [
                              //Name
                              TextFormField(
                                initialValue:
                                    appUser != null ? appUser.name : null,
                                onChanged: (value) {
                                  _nameInput = value;
                                },
                                decoration: inputDecoration.copyWith(
                                  labelText: 'Name',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(
                                height: height * 0.03,
                              ),
                              //PhoneNo
                              TextFormField(
                                initialValue:
                                    appUser != null ? appUser.phone : null,
                                onChanged: (value) {
                                  _phoneInput = value;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.phone,
                                decoration: inputDecoration.copyWith(
                                  labelText: 'Phone No',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Required';
                                  } else if (value.length != 10) {
                                    return 'Invalid Phone No.';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(
                                height: height * 0.03,
                              ),
                              //College
                              TextFormField(
                                initialValue:
                                    appUser != null ? appUser.college : null,
                                onChanged: (value) {
                                  _collegeInput = value;
                                },
                                decoration: inputDecoration.copyWith(
                                  labelText: 'College',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(
                                height: height * 0.03,
                              ),
                              //branch
                              DropdownButtonFormField(
                                decoration: inputDecoration.copyWith(
                                  labelText: 'Branch',
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                                elevation: 24,
                                icon: Icon(Icons.arrow_drop_down_rounded),
                                value: appUser != null
                                    ? appUser.branch
                                    : this._initialBranch,
                                onChanged: (String newValue) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    this._initialBranch = newValue;
                                  });
                                },
                                items: branches.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),

                              SizedBox(
                                height: height * 0.03,
                              ),
                              //Semester
                              DropdownButtonFormField(
                                decoration: inputDecoration.copyWith(
                                  labelText: 'Semester',
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                                elevation: 24,
                                icon: Icon(Icons.arrow_drop_down_rounded),
                                value: appUser != null
                                    ? appUser.sem
                                    : this._initialSem,
                                onChanged: (String newValue) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    this._initialSem = newValue;
                                  });
                                },
                                items: semester.map((int value) {
                                  return DropdownMenuItem<String>(
                                    value: value.toString(),
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                              ),

                              SizedBox(
                                height: height * 0.03,
                              ),

                              ButtonTheme(
                                height: height * 0.06,
                                minWidth: width * 0.5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: FlatButton(
                                  color: const Color(0xff000000),
                                  textColor: const Color(0xffffffff),
                                  child: Text(
                                    appUser != null
                                        ? 'Update'
                                        : 'Let\'s Get Started',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        isUploading = true;
                                      });

                                      // setting device token the first time
                                      if (appUser == null) {
                                        // setting up new notification status document for first time
                                        FirebaseServices()
                                            .uploadNewNotificationStatus(
                                                context, false);

                                        _newAppUser.dateTime =
                                            DateTime.now().toString();

                                        final FirebaseMessaging fcm =
                                            FirebaseMessaging();
                                        final String fcmToken =
                                            await fcm.getToken();
                                        final SharedPreferences
                                            sharedPreferences =
                                            await SharedPreferences
                                                .getInstance();
                                        sharedPreferences.setString(
                                            'fcmTokenKey', fcmToken);
                                        _newAppUser.deviceToken = fcmToken;
                                      } else {
                                        _newAppUser.deviceToken =
                                            appUser.deviceToken;
                                      }
                                      _newAppUser.name =
                                          _nameInput ?? appUser.name;
                                      _newAppUser.email =
                                          firebaseAppUser.email ??
                                              appUser.email;
                                      _newAppUser.phone =
                                          _phoneInput ?? appUser.phone;

                                      _newAppUser.college =
                                          _collegeInput ?? appUser.college;

                                      _newAppUser.branch =
                                          _initialBranch == null
                                              ? appUser.branch
                                              : _initialBranch;

                                      _newAppUser.sem = _initialSem == null
                                          ? appUser.sem
                                          : _initialSem;

                                      _newAppUser.uid = firebaseAppUser.uid;

                                      if (_image != null) {
                                        final String _photoUrl =
                                            await FirebaseServices()
                                                .uploadPictures(_image);

                                        _newAppUser.profilePhotoUrl = _photoUrl;
                                      } else {
                                        if (appUser != null)
                                          _newAppUser.profilePhotoUrl =
                                              appUser.profilePhotoUrl;
                                        else
                                          _newAppUser.profilePhotoUrl = null;
                                      }

                                      await FirebaseServices()
                                          .uploadAppUser(context, _newAppUser);

                                      Navigator.of(context).pushNamed(
                                        Index.routeName,
                                      );

                                      setState(() {
                                        isUploading = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
