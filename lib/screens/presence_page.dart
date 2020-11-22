import 'dart:async';

import 'package:fire_presence/model/user.dart';
import 'package:fire_presence/res/custom_colors.dart';
import 'package:fire_presence/utils/database.dart';
import 'package:flutter/material.dart';

class PresencePage extends StatefulWidget {
  final String userName;

  const PresencePage({@required this.userName});

  @override
  _PresencePageState createState() => _PresencePageState();
}

class _PresencePageState extends State<PresencePage> {
  Database database = Database();
  Timer timer;

  @override
  void initState() {
    database.updateUserPresence();
    timer = Timer.periodic(Duration(minutes: 1), (_) => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

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
            color: CustomColors.firebaseYellow,
            fontSize: 26,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size(100, 40.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'USERS',
                style: TextStyle(
                  color: CustomColors.firebaseAmber,
                  fontSize: 16,
                  letterSpacing: 3,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: StreamBuilder(
            stream: database.retrieveUsers(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, index) {
                    User userData = User.fromJson(snapshot.data.documents[index].data());
                    DateTime lastSeen =
                        DateTime.fromMillisecondsSinceEpoch(userData.lastSeenInEpoch);
                    DateTime currentDateTime = DateTime.now();

                    Duration differenceDuration = currentDateTime.difference(lastSeen);
                    String durationString = differenceDuration.inSeconds > 59
                        ? differenceDuration.inMinutes > 59
                            ? differenceDuration.inHours > 23
                                ? '${differenceDuration.inDays} ${differenceDuration.inDays == 1 ? 'day' : 'days'}'
                                : '${differenceDuration.inHours} ${differenceDuration.inHours == 1 ? 'hour' : 'hours'}'
                            : '${differenceDuration.inMinutes} ${differenceDuration.inMinutes == 1 ? 'minute' : 'minutes'}'
                        : 'few moments';

                    String presenceString = userData.presence ? 'Online' : '$durationString ago';

                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      horizontalTitleGap: 0,
                      leading: Icon(
                        Icons.circle,
                        size: 12.0,
                        color: userData.presence
                            ? Colors.greenAccent[400]
                            : CustomColors.firebaseGrey.withOpacity(0.4),
                      ),
                      title: Text(
                        userData.name,
                        style: TextStyle(
                          color: CustomColors.firebaseGrey,
                          fontSize: 26.0,
                        ),
                      ),
                      trailing: Text(
                        presenceString,
                        style: TextStyle(
                          color: userData.presence
                              ? Colors.greenAccent[400]
                              : CustomColors.firebaseGrey.withOpacity(0.4),
                          fontSize: 14.0,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    CustomColors.firebaseOrange,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
