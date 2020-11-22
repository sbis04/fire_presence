import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_presence/model/user.dart';
import 'package:fire_presence/utils/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  /// The main Firestore user collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  storeUserData({@required String userName}) async {
    DocumentReference documentReferencer = userCollection.doc(uid);

    User user = User(
      uid: uid,
      name: userName,
      presence: true,
      lastSeenInEpoch: DateTime.now().millisecondsSinceEpoch,
    );

    var data = user.toJson();

    await documentReferencer.set(data).whenComplete(() {
      print("User data added");
    }).catchError((e) => print(e));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', userName);

    updateUserPresence();
  }

  Stream<QuerySnapshot> retrieveUsers() {
    Stream<QuerySnapshot> queryUsers = userCollection
        // .where('uid', isNotEqualTo: uid)
        .orderBy('last_seen', descending: true)
        .snapshots();

    return queryUsers;
  }

  updateUserPresence() async {
    Map<String, dynamic> presenceStatusTrue = {
      'presence': true,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    };

    await databaseReference
        .child(uid)
        .update(presenceStatusTrue)
        .whenComplete(() => print('Updated your presence.'))
        .catchError((e) => print(e));

    Map<String, dynamic> presenceStatusFalse = {
      'presence': false,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    };

    databaseReference.child(uid).onDisconnect().update(presenceStatusFalse);
  }
}
