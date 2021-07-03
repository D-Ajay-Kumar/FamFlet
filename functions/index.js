const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();

exports.myFunction = functions.firestore
  .document('notifications/{message}')
  .onCreate(function(snapshot, context) {
    
    db.collection('newNotificationStatus').doc(snapshot.data().receiverUid).set({'newNotification': true});
   
    return admin.messaging().sendToDevice(snapshot.data().receiverDeviceToken, {
      notification: {
        icon: 'myicon3',
        // color: 'ff0000',
        title: snapshot.data().senderName,
        body: snapshot.data().subject,
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      },
    });
  });
