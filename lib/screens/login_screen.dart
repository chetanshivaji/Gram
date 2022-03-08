import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'myApp.dart';
import 'package:money/util.dart';
import 'package:money/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  static String id = "loginscreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                email = value;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your password.',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
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
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async {
                    //Implement registration functionality.
                    try {
                      final newUser = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (newUser != null) {
                        userMail = email;
                        //START Get users village and pin info. from user list.
                        var ls = await getLoggedInUserVillagePin();
                        village = ls[0];
                        pin = ls[1];
                        //END Get users village and pin info. from user list.
                        //START From village and pin get user approved and accessLevel
                        await FirebaseFirestore.instance
                            .collection(ls[0] + ls[1])
                            .doc('pendingApproval')
                            .collection("pending")
                            .doc(email)
                            .get()
                            .then(
                          (value) {
                            var y = value.data();
                            userApproved = y!['approved'];
                            userAccessLevel = y['accessLevel'];
                          },
                        );
                        if (userApproved == false) {
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                          onePopAlert(context, "Yet to be approved by Admin",
                              "Try After sometime Or remind admin to approve.");
                        } else {
                          Navigator.pushNamed(context, MyApp.id);
                          showRegLoginAlertDialogSuccess(context,
                              kTitleLoginSuccess, kSubTitleLoginSuccess);
                        }
                      }
                      //END From village and pin get user approved and accessLevel
                    } catch (e) {
                      showRegLoginAlertDialogFail(
                          context, kTitleFail, e.toString());
                    }
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Log In',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
