import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "registerationscreen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formRegKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = "";
  String registeredName = "";
  String password = "";
  String reEnterPassword = "";
  String village = "";
  String pin = "";
  bool onPressedRegister = false;
  @override
  Widget build(BuildContext context) {
    gContext = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Container(
            child: Form(
              key: _formRegKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 60),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(gContext)!
                              .msgEnterUserName;
                        }
                        registeredName = value;
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.person_add),
                        labelText:
                            AppLocalizations.of(gContext)!.labelName + txtStar,
                        hintText:
                            AppLocalizations.of(gContext)!.msgEnterUserName,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(gContext)!
                                  .msgEnterUserMail +
                              txtStar;
                        }
                        email = value.toLowerCase();
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText:
                            AppLocalizations.of(gContext)!.labelEmail + txtStar,
                        hintText:
                            AppLocalizations.of(gContext)!.msgEnterUserMail,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
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
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(gContext)!
                              .msgEnterPassword;
                        }
                        password = value;
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.password),
                        labelText:
                            AppLocalizations.of(gContext)!.labelPassword +
                                txtStar,
                        hintText:
                            AppLocalizations.of(gContext)!.msgEnterPassword,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
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
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(gContext)!
                              .msgEnterPassword;
                        }
                        reEnterPassword = value;
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.password),
                        labelText:
                            AppLocalizations.of(gContext)!.labelPassword +
                                txtStar,
                        hintText:
                            AppLocalizations.of(gContext)!.msgReEnterPassword,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
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
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(gContext)!
                              .msgEnterVillageName;
                        }
                        village = value.toLowerCase();
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.holiday_village),
                        labelText: AppLocalizations.of(gContext)!.labelVillage +
                            txtStar,
                        hintText:
                            AppLocalizations.of(gContext)!.msgEnterVillageName,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(gContext)!
                              .msgEnterVillagePin;
                        }
                        if (!isNumeric(value)) {
                          return msgOnlyNumber;
                        }

                        pin = value;
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.pin),
                        labelText:
                            AppLocalizations.of(gContext)!.labelPin + txtStar,
                        hintText:
                            AppLocalizations.of(gContext)!.msgEnterVillagePin,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
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
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      elevation: 5.0,
                      child: MaterialButton(
                        splashColor: clrBSplash,
                        minWidth: 200.0,
                        height: 42.0,
                        child: Text(
                          AppLocalizations.of(gContext)!.bLabelRegiter,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formRegKey.currentState!.validate() &&
                              onPressedRegister == false) {
                            onPressedRegister = true;
                            if (password != reEnterPassword) {
                              onPressedRegister =
                                  false; //if fail before on press succeed, it should be able to come back in again.
                              popAlert(
                                context,
                                AppLocalizations.of(gContext)!
                                    .titlePassMismatch,
                                AppLocalizations.of(gContext)!
                                    .subtitlePassMismatch,
                                getWrongIcon(50.0),
                                1,
                              );
                              return;
                            }
                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              if (newUser != null) {
                                userMail = email;
                                //Add entry of new user to users, village pin
                                await FirebaseFirestore.instance
                                    .collection(collUsers)
                                    .doc(email)
                                    .set(
                                  {
                                    keyVillage: village,
                                    keyPin: pin,
                                    keyAccessLevel: accessLevel.No
                                        .index, //access level set by admin decided type of use, eg .viewer, collector, admin, spender
                                    keyMail: email,
                                    keyIsAdmin: false,
                                    keyRegisteredName: registeredName,
                                  },
                                );
                                popAlert(
                                  context,
                                  AppLocalizations.of(gContext)!
                                      .kTitleRegisterationSuccess,
                                  AppLocalizations.of(gContext)!
                                      .kSubTitleRegisterationSuccess,
                                  getRightIcon(50.0),
                                  2,
                                );
                                return;
                              }
                            } catch (e) {
                              onPressedRegister = false;
                              popAlert(
                                context,
                                AppLocalizations.of(gContext)!
                                    .kTitleRegisterationFailed,
                                e.toString(),
                                getWrongIcon(50.0),
                                1,
                              );
                              return;
                              //treat exception caught
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
        ),
      ),
    );
  }
}
