const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const firestore = admin.firestore();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.onUserStatusChange = functions.database
  .ref("/{uid}/presence")
  .onUpdate(async (change, context) => {
    // Get the data written to Realtime Database
    const isOnline = change.after.val();

    // Then use other event data to create a reference to the
    // corresponding Firestore document.
    const userStatusFirestoreRef = firestore.doc(`users/${context.params.uid}`);

    if (!isOnline) {
      console.log("User went offline");
      return userStatusFirestoreRef.update({
        presence: false,
        last_seen: Date.now(),
      });
    } else {
      console.log("User is online");
      return null;
    }
  });
