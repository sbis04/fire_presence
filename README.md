# Fire Presence

A sample Flutter app for demonstrating how to update user presence on [Cloud Firestore](https://firebase.google.com/docs/firestore). There is no direct method present to do that, but it can be easily achieved using some other Firebase services, like [Firebase Realtime Database](https://firebase.google.com/docs/database) and [Cloud Functions](https://firebase.google.com/docs/functions).

## App screenshots

![](https://github.com/sbis04/fire_presence/raw/master/screenshot/fire_presence_app.png)

## Presence tracking in action

![](https://github.com/sbis04/fire_presence/raw/master/screenshot/presence_app_demo.gif)

## Plugins used

* [firebase_core](https://pub.dev/packages/firebase_core): for initializing Firebase.
* [firebase_auth](https://pub.dev/packages/firebase_auth): for using Firebase authentication.
* [google_sign_in](https://pub.dev/packages/google_sign_in): to implement Google Sign-In.
* [cloud_firestore](https://pub.dev/packages/cloud_firestore): for accessing Cloud Firestore.
* [firebase_database](https://pub.dev/packages/firebase_database): for accessing Firebase Realtime Database.
* [shared_preferences](https://pub.dev/packages/shared_preferences): for caching some user data on device (required for auto login).

## Cloud Firestore structure

![](https://github.com/sbis04/fire_presence/raw/master/screenshot/firestore_presence.png)

## Cloud Function

The Cloud Function is used for synchronizing the data from Realtime Database to Cloud Firestore is as follows:

```js
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const firestore = admin.firestore();

exports.onUserStatusChange = functions.database
  .ref("/{uid}/presence")
  .onUpdate(async (change, context) => {
    // Get the data written to Realtime Database
    const isOnline = change.after.val();

    // Get a reference to the Firestore document
    const userStatusFirestoreRef = firestore.doc(`users/${context.params.uid}`);
    
    console.log(`status: ${isOnline}`);

    // Update the values on Firestore
    return userStatusFirestoreRef.update({
      presence: isOnline,
      last_seen: Date.now(),
    });
  });
```

## Syncing user presence

![](https://github.com/sbis04/fire_presence/raw/master/screenshot/user_presence_firestore.gif)

## License

Copyright (c) 2020 Souvik Biswas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
