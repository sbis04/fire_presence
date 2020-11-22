import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_presence/model/user.dart';
import 'package:fire_presence/utils/authentication.dart';
import 'package:flutter/material.dart';

class Database {
  /// The main Firestore user collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

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
  }

  Stream<QuerySnapshot> retrieveUsers() {
    Stream<QuerySnapshot> queryUsers = userCollection.where('uid', isNotEqualTo: uid).snapshots();

    return queryUsers;
  }
}
