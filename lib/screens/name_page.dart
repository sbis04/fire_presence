import 'package:fire_presence/res/custom_colors.dart';
import 'package:fire_presence/screens/presence_page.dart';
import 'package:fire_presence/utils/authentication.dart';
import 'package:fire_presence/utils/database.dart';
import 'package:flutter/material.dart';

class NamePage extends StatefulWidget {
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  Database database = Database();

  TextEditingController textController;
  FocusNode textFocusNode;
  bool _isEditing = false;
  bool _isStoring = false;

  String _validateString(String value) {
    value = value.trim();

    if (textController.text != null) {
      if (value.isEmpty) {
        return 'Name can\'t be empty';
      }
    }

    return null;
  }

  @override
  void initState() {
    textController = TextEditingController(text: name);
    textFocusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        textFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomColors.firebaseNavy,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/firebase_logo.png',
                height: 30,
              ),
              SizedBox(width: 8),
              Text(
                'Fire',
                style: TextStyle(
                  color: CustomColors.firebaseYellow,
                  fontSize: 26,
                ),
              ),
              Text(
                ' Presence',
                style: TextStyle(
                  color: CustomColors.firebaseOrange,
                  fontSize: 26,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Column(
              children: [
                Row(),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        focusNode: textFocusNode,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          letterSpacing: 1.5,
                        ),
                        controller: textController,
                        cursorColor: Colors.white.withOpacity(0.5),
                        autofocus: false,
                        onChanged: (value) {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: CustomColors.firebaseYellow,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: CustomColors.firebaseYellow.withOpacity(0.5),
                            ),
                          ),
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                          ),
                          hintText: 'Enter your name',
                          hintStyle: TextStyle(
                            color: CustomColors.firebaseYellow.withOpacity(0.7),
                            fontSize: 18,
                            letterSpacing: 2,
                          ),
                          errorText: _isEditing ? _validateString(textController.text) : null,
                          errorStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _isStoring
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            CustomColors.firebaseOrange,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          width: double.maxFinite,
                          child: RaisedButton(
                            color: CustomColors.firebaseOrange,
                            onPressed: textController.text.isNotEmpty
                                ? () async {
                                    setState(() {
                                      _isStoring = true;
                                    });

                                    await database
                                        .storeUserData(userName: textController.text)
                                        .whenComplete(
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => PresencePage(
                                                userName: textController.text,
                                              ),
                                            ),
                                          ),
                                        )
                                        .catchError(
                                          (e) => print('Error in storing data: $e'),
                                        );

                                    setState(() {
                                      _isStoring = false;
                                    });
                                  }
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                              child: Text(
                                'CONTINUE',
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: textController.text.isNotEmpty
                                      ? CustomColors.firebaseGrey
                                      : Colors.white24,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
