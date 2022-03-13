import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'myApp.dart';
import 'package:money/util.dart';
import 'package:money/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = "loginscreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formLoginKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  bool onPressedLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formLoginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 60),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return msgEnterUserMail;
                    }
                    email = value
                        .toLowerCase(); //to avoid issue by upper case email typing.
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: labelEmail,
                    hintText: msgEnterUserMail,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return msgEnterPassword;
                    }
                    password = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.password),
                    labelText: labelPassword,
                    hintText: msgEnterPassword,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                  elevation: 5.0,
                  child: MaterialButton(
                    splashColor: clrBSplash,
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      bLabelLogin,
                    ),
                    onPressed: () async {
                      if (_formLoginKey.currentState!.validate() &&
                          onPressedLogin == false) {
                        onPressedLogin = true;
                        bool approvedUser = false;
                        try {
                          //check if email trying to login is admin.
                          bool res = await FirebaseFirestore.instance
                              .collection(collUsers)
                              .doc(email)
                              .get()
                              .then(
                            (value) async {
                              if (!value.exists) {
                                onPressedLogin = false;
                                //if allready present
                                popAlert(
                                  context,
                                  kTitleNotPresent,
                                  kSubTitleEmailPresent,
                                  getWrongIcon(50.0),
                                  2,
                                );
                                return false;
                              } else {
                                var y = value.data();
                                access = y![keyAccessLevel];
                                village = y[keyVillage];
                                pin = y[keyPin];
                                approvedUser = y[keyApproved];
                                return true;
                              }
                            },
                          );
                          if (!res) return;

                          if (approvedUser == true) {
                            final newUser =
                                await _auth.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            if (newUser != null) {
                              userMail = email;
                              Navigator.pushNamed(
                                context,
                                MyApp.id,
                              );
                            }
                          } else {
                            onPressedLogin = false;
                            popAlert(
                              context,
                              kTitleYetToApproveByAdmin,
                              kSubTitelYetToApproveByAdmin,
                              getWrongIcon(50.0),
                              1,
                            );
                            return;
                          }
                        } catch (e) {
                          onPressedLogin = false;
                          popAlert(
                            context,
                            kTitleFail,
                            e.toString(),
                            getWrongIcon(50.0),
                            2,
                          );
                          return;
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
