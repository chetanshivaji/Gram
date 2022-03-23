import 'package:flutter_sms/flutter_sms.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

bool whatsUpEnabled = false;
bool textMsgEnabled = true;
bool receiptPdf = true;

Future<void> launchWhatsApp(String whatsAppMsg, String mobile) async {
  //mobile number modification for +91
  String phoneWithCountryCode = "";
  if (mobile.contains("+")) {
    phoneWithCountryCode = mobile;
  } else {
    phoneWithCountryCode = "+91" + mobile;
  }
  final link = WhatsAppUnilink(
    phoneNumber: phoneWithCountryCode,
    text: whatsAppMsg,
  );
  // Convert the WhatsAppUnilink instance to a string.
  // Use either Dart's string interpolation or the toString() method.
  // The "launch" method is part of "url_launcher".
  await launch('$link');
  return;
}

Future<void> sendTextToPhone(String message, List<String> recipents) async {
  String _result = await sendSMS(message: message, recipients: recipents)
      .catchError((onError) {
    print(onError);
  });
  print(_result);
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

  await FlutterEmailSender.send(email);
  return;
}
