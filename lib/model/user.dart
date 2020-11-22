import 'package:flutter/material.dart';

class User {
  String uid;
  String name;
  bool presence;
  int lastSeenInEpoch;

  User({
    @required this.uid,
    @required this.name,
    @required this.presence,
    @required this.lastSeenInEpoch,
  });

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    presence = json['presence'];
    lastSeenInEpoch = json['last_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['uid'] = this.uid;
    data['name'] = this.name;
    data['presence'] = this.presence;
    data['last_seen'] = this.lastSeenInEpoch;

    return data;
  }
}
