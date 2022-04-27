import 'package:telephony/telephony.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

bool whatsUpEnabled = false;
bool textMsgEnabled = true;
bool receiptPdf = true;

Future<void> sendTextToPhone(String message, List<String> recipents) async {
  await Telephony.instance.sendSms(to: recipents[0], message: message);
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

  await FlutterEmailSender.send(email);
  return;
}
