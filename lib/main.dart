import 'package:fire_presence/screens/login_page.dart';
import 'package:fire_presence/screens/presence_page.dart';
import 'package:fire_presence/utils/authentication.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future getUserInfo() async {
    await getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Presence',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'GoogleSans',
      ),
      debugShowCheckedModeBanner: false,
      home:
          (uid != null && authSignedIn != false) ? PresencePage(userName: userName) : LoginPage(),
    );
  }
}
