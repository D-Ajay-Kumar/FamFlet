import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/appUser.dart';
import '../providers/firebaseAppUser.dart';
import '../providers/newNotification.dart';
import '../models/product.dart';
import '../providers/productsData.dart';
import '../providers/userProductsData.dart';
import '../providers/inTalksProductsData.dart';
import '../providers/bookmark.dart';
import '../providers/searchResults.dart';
import '../providers/appNotification.dart';
import '../providers/appNotificationsData.dart';
import '../constants.dart';

class FirebaseServices {
  // reference to users collection
  final CollectionReference _usersCollectionRef =
      FirebaseFirestore.instance.collection('users');

  // reference to products collection
  final CollectionReference _productsCollectionRef =
      FirebaseFirestore.instance.collection('products');

  // reference to support collection
  final CollectionReference _supportCollectionRef =
      FirebaseFirestore.instance.collection('support');

  // reference to bookmarks collection
  final CollectionReference _bookmarksCollectionRef =
      FirebaseFirestore.instance.collection('bookmarks');

  // reference to notifications collection
  final CollectionReference _notificationCollection =
      FirebaseFirestore.instance.collection('notifications');

  final CollectionReference _deletedProductsCollection =
      FirebaseFirestore.instance.collection('deletedProducts');

  final CollectionReference _newNotificationStatus =
      FirebaseFirestore.instance.collection('newNotificationStatus');

  // reference to storage
  final Reference _storageReference = FirebaseStorage.instance.ref();

  uploadDeviceToken(
      BuildContext context, User appUser, String deviceToken) async {
    await _usersCollectionRef
        .doc(appUser.uid)
        .update({'deviceToken': deviceToken});
  }

  uploadAppUser(BuildContext context, AppUser appUserObject) async {
    if (newUser) {
      // creating the user document for the first time
      await _usersCollectionRef
          .doc(appUserObject.uid)
          .set(appUserObject.toAppUserMap());

      newUser = false;
    } else {
      // updating the user document and changing data on created products
      await _usersCollectionRef
          .doc(appUserObject.uid)
          .set(appUserObject.toAppUserMap());

      // updates user data in all products docs of the user
      _productsCollectionRef
          .where('sellerUid', isEqualTo: appUserObject.uid)
          .get()
          .then(
        (querySnapshot) {
          for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            doc.reference.update(
              {
                'sellerName': appUserObject.name,
                'sellerCollege': appUserObject.college,
                'sellerBranch': appUserObject.branch,
                'sellerSem': appUserObject.sem,
                'sellerImage': appUserObject.profilePhotoUrl,
                'sellerPhone': appUserObject.phone,
              },
            );
          }
        },
      );

      // Updates user data in all notifications he has sent
      _notificationCollection
          .where('senderUid', isEqualTo: appUserObject.uid)
          .get()
          .then(
        (querySnapshot) {
          for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            doc.reference.update(
              {
                'senderName': appUserObject.name,
                'senderCollege': appUserObject.college,
                'senderBranch': appUserObject.branch,
                'senderSem': appUserObject.sem,
                'senderPhone': appUserObject.phone,
                'senderPictureUrl': appUserObject.profilePhotoUrl,
                'senderDeviceToken': appUserObject.deviceToken,
              },
            );
          }
        },
      );
    }

    final AppUser appUser = Provider.of<AppUser>(context, listen: false);
    appUser.setAppUser = appUserObject;
  }

  uploadRefreshedDeviceTokenOnProductsAndNotifications(
      String newToken, User appUser, BuildContext context) async {
    _productsCollectionRef
        .where('sellerUid', isEqualTo: appUser.uid)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.forEach(
            (doc) {
              doc.reference.update(
                {
                  'sellerDeviceToken': newToken,
                },
              );
            },
          );
        }
      },
    );

    _notificationCollection
        .where('senderUid', isEqualTo: appUser.uid)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.forEach(
            (doc) {
              doc.reference.update(
                {
                  'senderDeviceToken': newToken,
                },
              );
            },
          );
        }
      },
    );

    _notificationCollection
        .where('receiverUid', isEqualTo: appUser.uid)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.forEach(
            (doc) {
              doc.reference.update(
                {
                  'receiverDeviceToken': newToken,
                },
              );
            },
          );
        }
      },
    );
  }

  uploadNewNotificationStatus(BuildContext context, bool value) async {
    final NewNotification newNotification =
        Provider.of<NewNotification>(context, listen: false);
    newNotification.setNewNotification = value;

    final User firebaseAppUser =
        Provider.of<FirebaseAppUser>(context, listen: false).getFirebaseAppUser;

    await _newNotificationStatus.doc(firebaseAppUser.uid).set(
      {
        'newNotification': value,
      },
    );
  }

  downloadNewNotificationStatus(BuildContext context) async {
    final NewNotification newNotification =
        Provider.of<NewNotification>(context, listen: false);

    final User appUser =
        Provider.of<FirebaseAppUser>(context, listen: false).getFirebaseAppUser;
    final DocumentSnapshot doc =
        await _newNotificationStatus.doc(appUser.uid).get();

    final bool value = doc.data()['newNotification'];

    newNotification.setNewNotification = value;
  }

  downloadAppUser(BuildContext context) async {
    final AppUser appUser = Provider.of<AppUser>(context, listen: false);

    FirebaseAppUser firebaseAppUser =
        Provider.of<FirebaseAppUser>(context, listen: false);

    final DocumentSnapshot documentSnapshot = await _usersCollectionRef
        .doc(firebaseAppUser.getFirebaseAppUser.uid)
        .get();

    final Map<String, dynamic> appUserDataMap = documentSnapshot.data();

    final AppUser appUserObject = AppUser();
    appUserObject.toAppUserObject(appUserDataMap);
    appUser.setAppUser = appUserObject;
  }

  uploadProduct(BuildContext context, Product productObject) async {
    String status = 'Edited';
    if (productObject.uid == null) {
      final DocumentReference docRef = _notificationCollection.doc();
      productObject.uid = docRef.id;

      status = 'New';
    }

    await _productsCollectionRef
        .doc(productObject.uid)
        .set(productObject.toProductMap());

    final ProductsData productsData =
        Provider.of<ProductsData>(context, listen: false);
    productsData.addProduct(productObject, status);

    final UserProductsData userProductsData =
        Provider.of<UserProductsData>(context, listen: false);
    userProductsData.addProduct(productObject, status);
  }

  uploadProductAvailability(
      // makes product available and unavailable when offer is accepted
      BuildContext context,
      String productUid,
      bool status) async {
    await _productsCollectionRef
        .doc(productUid)
        .update({'isAvailable': status});

    // makes that product unavailable in every user's bookmarks
    // also makes it available if it is reposted
    final Bookmark bookmark = Provider.of<Bookmark>(context, listen: false);
    bookmark.removeBookmark(productUid);
    final Query bookmarksRef =
        _bookmarksCollectionRef.where('uid', isEqualTo: productUid);
    bookmarksRef.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({'isAvailable': status});
      });
    });
  }

  Future<String> uploadPictures(File image) async {
    // uploads picture(s) to storage and return it's URL
    final Reference ref =
        _storageReference.child('${Path.basename(image.path)}}');

    final UploadTask uploadTask = ref.putFile(image);
    // final TaskSnapshot storageTaskSnapshot =
    String pictureUrl;
    await uploadTask.then((taskSnapshot) async {
      pictureUrl = await taskSnapshot.ref.getDownloadURL();
    });

    return pictureUrl;
  }

  deleteProduct(BuildContext context, Product product) async {
    // deleting bookmarks of that product
    final Bookmark bookmark = Provider.of<Bookmark>(context, listen: false);
    bookmark.removeBookmark(product.uid);
    final Query bookmarksRef =
        _bookmarksCollectionRef.where('uid', isEqualTo: product.uid);
    bookmarksRef.get().then(
      (querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            doc.reference.delete();
          },
        );
      },
    );

    // deleting notifications of that product
    // do not delete this
    // final AppNotificationsData appNotificationsData =
    //     Provider.of<AppNotificationsData>(context, listen: false);
    // appNotificationsData.removeNotification(product.uid);
    // final Query notificationsRef =
    //     _bookmarksCollectionRef.where('productUid', isEqualTo: product.uid);
    // notificationsRef.get().then(
    //   (querySnapshot) {
    //     querySnapshot.docs.forEach(
    //       (doc) {
    //         doc.reference.delete();
    //       },
    //     );
    //   },
    // );

    // adding to deleted products collection
    final ProductsData productsData =
        Provider.of<ProductsData>(context, listen: false);
    productsData.removeProduct(product.uid);

    await _deletedProductsCollection
        .doc(product.uid)
        .set(product.toProductMap());

    // removing from user products list
    final UserProductsData userProductsData =
        Provider.of<UserProductsData>(context, listen: false);
    userProductsData.removeProduct(product.uid);

    // removing from in talks products list
    final InTalksProductsData inTalksProductsData =
        Provider.of<InTalksProductsData>(context, listen: false);
    inTalksProductsData.removeProduct(product.uid);

    // deleting the product
    await _productsCollectionRef.doc(product.uid).delete();
  }

  downloadSupportData(BuildContext context) async {
    final QuerySnapshot supportQs = await _supportCollectionRef.get();

    return supportQs;
  }

  downloadProductsList(BuildContext context) async {
    // downloads all the products
    final ProductsData productsData =
        Provider.of<ProductsData>(context, listen: false);

    final QuerySnapshot productsQS = await _productsCollectionRef
        .where('isAvailable', isEqualTo: true)
        .orderBy('dateTime')
        .get();

    List<Product> productsList = [];

    // converts doc's map data into Product object and
    // stores in the above list
    productsQS.docs.forEach(
      (productQDS) {
        Product productObject = Product();
        final productMapData = productQDS.data();
        if (productMapData.isNotEmpty) {
          productObject.toProductObject(productMapData);

          productsList.add(productObject);
        } else {
          return;
        }
      },
    );

    // setting list in products data to show on home screen
    productsData.setProductsList = productsList.reversed.toList();
  }

  downloadUserProducts(BuildContext context) async {
    final AppUser appUser =
        Provider.of<AppUser>(context, listen: false).getAppUserObject;

    final List<Product> productsList =
        Provider.of<ProductsData>(context, listen: false).getProductsList;

    final UserProductsData userProductsData =
        Provider.of<UserProductsData>(context, listen: false);

    // setting list in user products data to show on user profile screen
    final List<Product> userProductsList = [
      ...productsList.where(
        (product) {
          return product.sellerUid == appUser.uid &&
              product.isAvailable == true;
        },
      )
    ];
    Future.delayed(
      Duration.zero,
      () {
        userProductsData.setUserProducts = userProductsList;
      },
    );
  }

  downloadInTalksProducts(BuildContext context) async {
    final AppUser appUser =
        Provider.of<AppUser>(context, listen: false).getAppUserObject;

    final InTalksProductsData inTalksProductsData =
        Provider.of<InTalksProductsData>(context, listen: false);

    final QuerySnapshot querySnapshot = await _productsCollectionRef
        .where('sellerUid', isEqualTo: appUser.uid)
        .where('isAvailable', isEqualTo: false)
        .orderBy('dateTime')
        .get();

    final List<Product> inTalksProducts = [];

    querySnapshot.docs.forEach(
      (productQDS) {
        Product productObject = Product();
        final productMapData = productQDS.data();
        if (productMapData.isNotEmpty) {
          productObject.toProductObject(productMapData);

          inTalksProducts.add(productObject);
        } else {
          return;
        }
      },
    );

    // setting list in inTalks products data to show on user profile screen

    Future.delayed(
      Duration.zero,
      () {
        inTalksProductsData.setInTalksProducts =
            inTalksProducts.reversed.toList();
      },
    );
  }

  manageBookmark(
      BuildContext context, Product product, String productUid) async {
    // uploads and removes bookmark
    final AppUser appUser =
        Provider.of<AppUser>(context, listen: false).getAppUserObject;

    final Bookmark bookmarks = Provider.of<Bookmark>(context, listen: false);

    final DocumentReference bookmarkDoc =
        _bookmarksCollectionRef.doc(appUser.uid + productUid);

    Bookmark bookmark = Bookmark();
    if (product != null) {
      bookmark.toBookmarkFromProduct(product);
    }
    bookmark.appUserUid = appUser.uid;
    bookmark.uid = productUid;

    if (!bookmarks.getBookmarks.any((element) => element.uid == productUid)) {
      final bookmarkMap = bookmark.toBookmarkMap();

      bookmarks.addBookmark(bookmark);
      await bookmarkDoc.set(bookmarkMap);
    } else {
      if (product != null) {
        bookmarks.removeBookmark(bookmark.uid);
      }
      await bookmarkDoc.delete();
    }
  }

  downloadBookmarks(BuildContext context) async {
    final AppUser appUser =
        Provider.of<AppUser>(context, listen: false).getAppUserObject;
    final Bookmark bookmarksProvider =
        Provider.of<Bookmark>(context, listen: false);

    final QuerySnapshot bookmarksQS = await _bookmarksCollectionRef
        .where('appUserUid', isEqualTo: appUser.uid)
        .where('isAvailable', isEqualTo: true)
        .get();

    List<Bookmark> bookmarksList = [];

    bookmarksQS.docs.forEach(
      (bookmarkQDS) {
        Bookmark bookmarkObject = Bookmark();
        final bookmarkMapData = bookmarkQDS.data();
        bookmarkObject.toBookmarkFromMap(bookmarkMapData);

        bookmarksList.add(bookmarkObject);
      },
    );
    bookmarksProvider.setBookmarks = bookmarksList;
  }

  downloadSearchResults(BuildContext context, String keyword) async {
    final searchResultsProvider =
        Provider.of<SearchResults>(context, listen: false);
    final QuerySnapshot searchTitleQS =
        await _productsCollectionRef.where('title', isEqualTo: keyword).get();

    final QuerySnapshot searchDescriptionQS = await _productsCollectionRef
        .where('description', isEqualTo: keyword)
        .get();

    final List<Product> searchResults = [];

    searchTitleQS.docs.forEach(
      (searchQDS) {
        final Product searchedProduct = Product();
        searchedProduct.toProductObject(searchQDS.data());
        searchResults.add(searchedProduct);
      },
    );

    searchDescriptionQS.docs.forEach(
      (searchQDS) {
        final Product searchedProduct = Product();
        searchedProduct.toProductObject(searchQDS.data());
        searchResults.add(searchedProduct);
      },
    );

    searchResultsProvider.setSearchList = searchResults;
  }

  uploadNotification(AppNotification appNotificationObject) async {
    final DocumentReference docRef = _notificationCollection.doc();
    appNotificationObject.notificationUid = docRef.id;
    await docRef.set(
      appNotificationObject.toNotificationMap(),
    );
  }

  uploadNotificationResponse(
      BuildContext context, String notificationUid, String response) async {
    await _notificationCollection.doc(notificationUid).update(
      {
        'response': response,
      },
    );
  }

  downloadNotifications(BuildContext context) async {
    final AppUser appUser =
        Provider.of<AppUser>(context, listen: false).getAppUserObject;

    final AppNotificationsData appNotificationsData =
        Provider.of<AppNotificationsData>(context, listen: false);

    final QuerySnapshot receivedNotifications = await _notificationCollection
        .where('receiverUid', isEqualTo: appUser.uid)
        .orderBy('dateTime')
        .get();

    List<AppNotification> notificationsList = [];

    receivedNotifications.docs.forEach(
      (notification) {
        final AppNotification notificationObject = AppNotification();
        notificationObject.toNotificationObject(notification.data());
        notificationsList.add(notificationObject);
      },
    );
    appNotificationsData.setNotifications = notificationsList.reversed.toList();
  }

  uploadUpdatedReadStatus(String notificationUid) async {
    await _notificationCollection.doc(notificationUid).update(
      {
        'readStatus': true,
      },
    );
  }

  uploadUpdatedAnsweredStatus(String notificationUid) async {
    await _notificationCollection.doc(notificationUid).update(
      {
        'isAnswered': true,
      },
    );
  }

  uploadNotificationAnswered(String notificationUid) async {
    await _notificationCollection.doc(notificationUid).update(
      {
        'isAnswered': true,
      },
    );
  }
}
