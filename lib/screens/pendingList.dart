import 'package:flutter/material.dart';
import 'package:money/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/util.dart';
import 'package:money/communication.dart';
import 'package:money/model/receipt.dart';
import 'package:money/api/pdf_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class pendingList extends StatelessWidget {
  String pendingType = "";
  String orderType = "";
  String yearDropDownValue = "";

  pendingList(
      {Key? key,
      this.yearDropDownValue = "2021",
      this.pendingType = keyHouseGiven,
      this.orderType = keyDate})
      : super(key: key);

  Future<void> createPDFInHouseWaterReceiptEntries(
      String name, String amount, String mobile, String taxType) async {
    //START - fetch data to display in pdf

    final receipt = pendingReceipt(
      info: receiptInfo(
          date: getCurrentDateTimeInDHM(),
          name: name,
          amount: amount.toString(),
          mobile: mobile,
          userMail: registeredName,
          taxType: (taxType == txtTaxTypeHouse) ? keyHouse : keyWater),
    );

    final pdfFile =
        await receipt.generate(actPending + dropdownValueYear, registeredName);

    //PdfApi.openFile(pdfFile);
    return;
    //END - fetch data to display in pdf
  }

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> docSnapshot) {
    List<DataRow> ldataRow = [];
    int srNo = 0;
    for (var l in docSnapshot) {
      List<DataCell> ldataCell = [];
      srNo = srNo + 1;
      ldataCell.add(DataCell(Text(
        srNo.toString(),
        style: getTableFirstColStyle(),
      )));
      ldataCell.add(DataCell(Text(l.get(keyName))));
      ldataCell.add(DataCell(Text(l.get(keyMobile))));
      ldataCell.add(DataCell(Text(l.get(keyUid))));
      if (pendingType == housePendingType) {
        ldataCell.add(DataCell(Text(l.get(keyHouse).toString())));
      } else {
        ldataCell.add(DataCell(Text(l.get(keyWater).toString())));
      }
      ldataCell.add(
        DataCell(
          IconButton(
            splashColor: clrIconSpalsh,
            splashRadius: iconSplashRadius,
            onPressed: () async {
              String name = l.get(keyName);
              String mobile = l.get(keyMobile);
              String email = l.get(keyEmail);
              String uid = l.get(keyUid);
              String amount = "";
              String notifyTaxType = "";
              if (pendingType == housePendingType) {
                amount = l.get(keyHouse).toString();
                notifyTaxType = txtTaxTypeHouse;
              } else {
                amount = l.get(keyWater).toString();
                notifyTaxType = txtTaxTypeWater;
              }

              String videoLinkForCu =
                  "dummy youtube link https://www.youtube.com/watch?v=nYHQxOu0V3k";
              String notificationMessage =
                  "Dear $name, $mobile, ID-$uid Reminder notice. Please pay pending $notifyTaxType tax amount $amount for year $dropdownValueYear to Grampanchayat. See how this system works on $videoLinkForCu"; //who is reminding
              String mobileWhatsApp = l.get(keyMobile);
              List<String> listMobile = [mobileWhatsApp];
////////*******************START sending mail************************/////
              await createPDFInHouseWaterReceiptEntries(
                  name, amount, mobile + " " + uid, notifyTaxType);

              String subject =
                  "$name, ID $uid, $notifyTaxType Tax Pending receipt for year $dropdownValueYear";
              String body = """$notificationMessage
Please find attached PENDING receipt.

Regards,
$registeredName
""";
              String attachment = gReceiptPdfName;

              List<String> receipients = [
                email,
                adminMail,
              ];
              await sendEmail(subject, body, receipients,
                  attachment); //send mail to user cc admin
////////*******************END sending mail************************/////
              if (textMsgEnabled)
                await sendTextToPhone(
                    notificationMessage + "-" + registeredName, listMobile);
            },
            icon: Icon(
              Icons.notifications_active_outlined,
              color: Colors.red,
            ),
            tooltip: txtNotifyToPay,
          ),
        ),
      );
      ldataCell.add(
        DataCell(
          IconButton(
            splashColor: clrIconSpalsh,
            splashRadius: iconSplashRadius,
            onPressed: () async {
              String name = l.get(keyName);
              String mobile = l.get(keyMobile);
              String email = l.get(keyEmail);
              String uid = l.get(keyUid);
              String amount = "";
              String notifyTaxType = "";
              if (pendingType == housePendingType) {
                amount = l.get(keyHouse).toString();
                notifyTaxType = txtTaxTypeHouse;
              } else {
                amount = l.get(keyWater).toString();
                notifyTaxType = txtTaxTypeWater;
              }
              String OnlinePaymentLink = "dummy link";
              String notificationMessage =
                  "Dear $name, $mobile, ID-$uid. Pay online, pending $notifyTaxType tax amount Rs. $amount for year $dropdownValueYear to Grampanchayat through link $OnlinePaymentLink"; //who is reminding
              String mobileWhatsApp = l.get(keyMobile);
              List<String> listMobile = [mobileWhatsApp];
////////*******************START sending mail************************/////

              String subject =
                  "$name, ID $uid, $notifyTaxType tax Online Payment link for year- $dropdownValueYear";
              String body = """$notificationMessage
Regards,
$registeredName
""";

              List<String> receipients = [
                email,
                adminMail,
              ];
              await sendEmailNoAttachment(
                  subject, body, receipients); //send mail to user cc admin
////////*******************END sending mail************************/////
              if (textMsgEnabled)
                await sendTextToPhone(
                    notificationMessage + "-" + registeredName, listMobile);
            },
            icon: Icon(
              Icons.mobile_screen_share,
              color: Colors.blue,
            ),
            tooltip: txtNotifyToPayOnline,
          ),
        ),
      );
      ldataRow.add(
        DataRow(cells: ldataCell),
      );
    }
    return ldataRow;
  }

  SingleChildScrollView getInHouseWaterTable(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: getTableHeadingTextStyle(),
          border: getTableBorder(),
          dataTextStyle: TextStyle(
            color: Colors.indigoAccent,
          ),
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeading_srNum,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingName,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingMobile,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingUid,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingAmount,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingNotify,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingOnlinePayment,
                style: getStyle(actPending),
              ),
            ),
          ],
          rows: _buildList(context, snapshot.data!.docs),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    gContext = context;
    Stream<QuerySnapshot<Object?>> stm;
    if (pendingType == housePendingType) {
      if (orderType == AppLocalizations.of(gContext)!.txtLtoH) {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yearDropDownValue)
            .where(keyHouseGiven, isEqualTo: false)
            .orderBy(keyHouse, descending: false)
            .snapshots();
      } else if (orderType == AppLocalizations.of(gContext)!.txtHtoL) {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yearDropDownValue)
            .where(keyHouseGiven, isEqualTo: false)
            .orderBy(keyHouse, descending: true)
            .snapshots();
      } else {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yearDropDownValue)
            .where(keyHouseGiven, isEqualTo: false)
            .orderBy(keyHouse, descending: true)
            .snapshots();
      }
    } else {
      if (orderType == AppLocalizations.of(gContext)!.txtLtoH) {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yearDropDownValue)
            .where(keyWaterGiven, isEqualTo: false)
            .orderBy(keyWater, descending: false)
            .snapshots();
      } else if (orderType == AppLocalizations.of(gContext)!.txtHtoL) {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yearDropDownValue)
            .where(keyWaterGiven, isEqualTo: false)
            .orderBy(keyWater, descending: true)
            .snapshots();
      } else {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yearDropDownValue)
            .where(keyWaterGiven, isEqualTo: false)
            .orderBy(keyWater, descending: true)
            .snapshots();
      }
    }

    return StreamBuilder<QuerySnapshot>(
      stream: stm,
      //Async snapshot.data-> query snapshot.docs -> docuemnt snapshot,.data["key"]
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(msgNoExpense);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(msgLoading);
        }

        return getInHouseWaterTable(context, snapshot);
      },
    );
  }
}
