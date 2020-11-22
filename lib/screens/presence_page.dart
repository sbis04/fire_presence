import 'package:fire_presence/res/custom_colors.dart';
import 'package:flutter/material.dart';

class PresencePage extends StatefulWidget {
  final String userName;

  const PresencePage({@required this.userName});

  @override
  _PresencePageState createState() => _PresencePageState();
}

class _PresencePageState extends State<PresencePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: Text(
          widget.userName,
          style: TextStyle(
            color: CustomColors.firebaseOrange,
            fontSize: 26,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Container(),
        ),
      ),
    );
  }
}
