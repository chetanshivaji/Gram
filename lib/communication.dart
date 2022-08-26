import 'package:telephony/telephony.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'util.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

bool whatsUpEnabled = false;
bool textMsgEnabled = true;
bool receiptPdf = true;

const urlPrefix = 'https://api.textlocal.in/send/?';
Future<void> sendSMS(apikey, numbers, sender, message, unicode) async {
  final url = Uri.parse(urlPrefix);
  final json = {
    'apikey': apikey,
    'numbers': numbers,
    'message': message,
    'sender': sender,
    'unicode': unicode
  };

  final response = await http.post(url, body: json);
  //START check failure
  Map valueMap = jsonDecode(response.body); //convert string to json Map.
  bool failure = false;
  if (valueMap["status"] == "failure") {
    //TODO: check response.statusCode tomorrow for failure
    failure = true;
  }
  if (failure == true) {
    popAlert(gContext, AppLocalizations.of(gContext)!.kTitleTextMessageFail,
        valueMap["errors"].toString(), getWrongIcon(50.0), 1);
  }
  //END check failure
  /*
  print('Status code: ${response.statusCode}');
  print('Headers: ${response.headers}');
  print('Body: ${response.body}');
  */
}

Future<void> sendTextToPhoneThroughTextLocal(
    String message, List<String> recipents) async {
  //String message =
  //  "Hi there, thank you for sending your first test message from Textlocal. Get 20% off today with our code: shubm.";
  String apiKey = "Njc2NjdhNGQ0MjU5MzA0OTQ2NzE3YTMxMzE1MDYzNDU=";
  String sender = "PHLSFT";
  String unicode =
      "false"; //For regional languages like Hindi Marathi it is true.
  unicode =
      (AppLocalizations.of(gContext)!.language == "English") ? "false" : "true";

  await sendSMS(apiKey, recipents[0], sender, message, unicode);
  return;
}

Future<void> sendTextToPhone(String message, List<String> recipents) async {
  if (fromTextLocal == true) {
    await sendTextToPhoneThroughTextLocal(message, recipents);
  } else {
    await Telephony.instance
        .sendSms(to: recipents[0], message: message, isMultipart: true);
  }

  return;
}

Future<void> sendEmail(String subject, String body, List<String> recipients,
    String attachment) async {
  //WOW! if to and cc are same only to is considered and cc is redudent.
  final Email email = Email(
    subject: subject,
    body: body,
    recipients: [recipients[0]], //user
    cc: [recipients[1]], //admin
    //bcc: ['bcc@example.com'] ,
    attachmentPaths: [attachment],
    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
  } catch (error) {
    //print(error);
    popAlert(gContext, AppLocalizations.of(gContext)!.kTitleTextMessageFail,
        error.toString(), getWrongIcon(50.0), 1);
  }
  return;
}

Future<void> sendEmailNoAttachment(
    String subject, String body, List<String> recipients) async {
  //WOW! if to and cc are same only to is considered and cc is redudent.
  final Email email = Email(
    subject: subject,
    body: body,
    recipients: [recipients[0]], //user
    cc: [recipients[1]], //admin
    //bcc: ['bcc@example.com'] ,
    //attachmentPaths: [attachment],
    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
  } catch (error) {
    //print(error);
    popAlert(gContext, AppLocalizations.of(gContext)!.kTitleTextMessageFail,
        error.toString(), getWrongIcon(50.0), 1);
  }
  return;
}
