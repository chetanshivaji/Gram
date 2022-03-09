import 'package:flutter/material.dart';

String kTitleFail = "Login/registeration failed";
String kSubtitleFail = "Try again with correct username & password";

String kTitleLoginSuccess = "login success";
String kSubTitleLoginSuccess = "login success";

String kTitleRegisterationSuccess = "Registered";
String kSubTitleRegisterationSuccess =
    "You are registered wait for admin to approve.";

String kTitleRegisterationFailed = "Registeration Fail";

String titlePassMismatch = "Password mismatch";
String subtitlePassMismatch = "passwrod and re entered password should match";

String colletionName_forumla = "formula";
String documentName_formula = "calculation";

String housePendingType = "houseGiven";
String waterPendingType = "waterGiven";

String dbYearPrefix = "mainDb";
String paidMsg = "paid already";
const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
