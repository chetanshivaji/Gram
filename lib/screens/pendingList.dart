import 'package:flutter/material.dart';
import 'package:money/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/util.dart';
import 'package:money/communication.dart';
import 'package:money/api/pdf_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:money/model/receipt_pending.dart';

class pendingList extends StatelessWidget {
  String pendingType = "";
  String orderType = "";
  String yearDropDownValue = "";

  String electricityTax = "";
  String healthTax = "";
  String extraLandTax = "";
  String otherTax = "";
  String totalTax = "";
  String discount = "";
  String fine = "";

  pendingList(
      {Key? key,
      this.yearDropDownValue = "2021",
      this.pendingType = keyHouseGiven,
      this.orderType = keyDate})
      : super(key: key);

  Future<void> createPDFInHouseWaterReceiptEntries(
      String name,
      bool houseGiven,
      bool waterGiven,
      String houseTax,
      String waterTax,
      String mobile,
      String uid,
      String taxType) async {
    //START - fetch data to display in pdf

    final receipt = pendingReceipt(
      info: pendingReceiptInfo(
          date: getCurrentDateTimeInDHM(),
          houseGiven: houseGiven,
          waterGiven: waterGiven,
          name: name,
          houseTax: houseTax.toString(),
          waterTax: waterTax.toString(),
          electricityTax: electricityTax,
          healthTax: healthTax,
          extraLandTax: extraLandTax,
          otherTax: otherTax,
          totalTax: totalTax,
          mobile: mobile,
          uid: uid,
          userMail: registeredName,
          //Pdf only in english because of Marathi font disturbed.
          /*
          taxType: (taxType == AppLocalizations.of(gContext)!.txtTaxTypeHouse)
              ? AppLocalizations.of(gContext)!.txtTaxTypeHouse
              : AppLocalizations.of(gContext)!.txtTaxTypeWater),
              */
          taxType: (taxType == AppLocalizations.of(gContext)!.txtTaxTypeHouse)
              ? txtTaxTypeHouse
              : txtTaxTypeWater),
    );

    /*
  //Pdf only in english because of Marathi font disturbed.
    final pdfFile = await receipt.generate(
        AppLocalizations.of(gContext)!.pageNamePending + dropdownValueYear,
        registeredName);
        */

    final pdfFile = await receipt.generate(
        pageNamePending + dropdownValueYear, registeredName);
    //PdfApi.openFile(pdfFile);
    return;
    //END - fetch data to display in pdf
  }

  bool remindLimitCrossed(
      BuildContext context, int remindCount, String mobile, String uid) {
    if (remindCount == 0) {
      popAlert(
        context,
        AppLocalizations.of(gContext)!.kTitleTryCatchFail,
        AppLocalizations.of(gContext)!.subtitleRemindLimit,
        getWrongIcon(50.0),
        1,
      );
      return true;
    }
    FirebaseFirestore.instance
        .collection(village + pin)
        .doc(docMainDb)
        .collection(docMainDb + yearDropDownValue)
        .doc(mobile + uid)
        .update(
      {
        keyRemindCount: remindCount - 1,
      },
    );

    return false;
  }

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> docSnapshot) {
    //START - multi linugal string
    String dear = AppLocalizations.of(gContext)!.txtDear;
    String reminder = AppLocalizations.of(gContext)!.txtReminder;
    String taxPendingReceipt =
        AppLocalizations.of(gContext)!.txtTaxpPendingRecieptForYear;
    String findPendingReceipt =
        AppLocalizations.of(gContext)!.txtFindPendingReceipt;
    String onlinePaymentLink = AppLocalizations.of(gContext)!.txtOnlinePayLink;
    String taxAmount = AppLocalizations.of(gContext)!.txtTaxAmount;
    String yr = AppLocalizations.of(gContext)!.tableHeadingYear;
    String vlg = AppLocalizations.of(gContext)!.labelVillage;
    String ud = AppLocalizations.of(gContext)!.tableHeadingUid;
    String payOnline = AppLocalizations.of(gContext)!.txtPayOnline;
    String forYear = AppLocalizations.of(gContext)!.txtForYear;
    String pending = AppLocalizations.of(gContext)!.pageNamePending;
    String youtubeLink = AppLocalizations.of(gContext)!.txtYoutubeLink;
    String howSystemWorks = AppLocalizations.of(gContext)!.txtHowSystemWorks;

    String regards = AppLocalizations.of(gContext)!.txtRegards;

    String keyord_electricityTax =
        AppLocalizations.of(gContext)!.labelElectricityTax;
    String keyord_healthTax = AppLocalizations.of(gContext)!.labelHealthTax;
    String keyord_extraLandTax =
        AppLocalizations.of(gContext)!.labelExtraLandTax;
    String keyord_otherTax = AppLocalizations.of(gContext)!.labelOtherTax;
    String keyord_totalTax = AppLocalizations.of(gContext)!.labelTotalTax;

    //END - multi linugal string
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
        ldataCell
            .add(DataCell(Text(l.get(keyTotalTaxOtherThanWater).toString())));
      } else {
        ldataCell.add(DataCell(Text(l.get(keyWater).toString())));
      }
      ldataCell.add(
        DataCell(
          IconButton(
            splashColor: clrIconSpalsh,
            splashRadius: iconSplashRadius,
            onPressed: () async {
              bool rLimitCrossed = remindLimitCrossed(context,
                  l.get(keyRemindCount), l.get(keyMobile), l.get(keyUid));

              if (rLimitCrossed == true) return;

              String name = l.get(keyName);
              String mobile = l.get(keyMobile);
              String email = l.get(keyEmail);
              String uid = l.get(keyUid);
              String houseAmount = "";
              String waterAmount = "";
              houseAmount = l.get(keyHouse).toString();
              waterAmount = l.get(keyWater).toString();

              /*
              String electricityTax = "";
              String healthTax = "";
              String extraLandTax = "";
              String otherTax = "";
              String totalTax = "";
              */

              electricityTax = l.get(keyElectricity).toString();
              healthTax = l.get(keyHealth).toString();
              extraLandTax = l.get(keyExtraLand).toString();
              otherTax = l.get(keyOtherTax).toString();
              totalTax = l.get(keyTotalTaxOtherThanWater).toString();

              String notifyTaxType = "";
              String houseTaxType = "";
              String waterTaxType = "";
              houseTaxType = AppLocalizations.of(gContext)!.txtTaxTypeHouse;
              waterTaxType = AppLocalizations.of(gContext)!.txtTaxTypeWater;
              String received = "0";

              String notificationMessage = "";
              String videoLinkForCu =
                  "$youtubeLink https://youtu.be/LPBDvJKDug8";

              String taxRemindInfo = "";
              if (l.get(keyHouseGiven)) {
                taxRemindInfo = '''
$waterTaxType-$waterAmount
''';
              } else if (l.get(keyWaterGiven)) {
                taxRemindInfo = '''
$houseTaxType-$houseAmount
$keyord_electricityTax-$electricityTax
$keyord_healthTax-$healthTax
$keyord_extraLandTax-$extraLandTax
$keyord_otherTax-$otherTax
$keyord_totalTax-$totalTax
''';
              } else {
                //both house water tax not given. form generic message.
                taxRemindInfo = '''
$houseTaxType-$houseAmount
$keyord_electricityTax-$electricityTax
$keyord_healthTax-$healthTax
$keyord_extraLandTax-$extraLandTax
$keyord_otherTax-$otherTax
$keyord_totalTax-$totalTax

$waterTaxType-$waterAmount
''';
              }

              notifyTaxType = AppLocalizations.of(gContext)!.txtTaxTypeHouse;

              notificationMessage = '''$dear $name,
$mobile
$ud-$uid
$yr-$dropdownValueYear
$reminder.
$taxAmount,

$taxRemindInfo
$vlg-$village $pin
$howSystemWorks, $videoLinkForCu'''; //who is reminding

              String mobileWhatsApp = l.get(keyMobile);
              List<String> listMobile = [mobileWhatsApp];
////////*******************START sending mail************************/////
              if (l.get(keyHouseGiven)) {
                houseAmount = "0";
                totalTax = "0";
              } else if (l.get(keyWaterGiven)) waterAmount = "0";

              await createPDFInHouseWaterReceiptEntries(
                  name,
                  l.get(keyHouseGiven),
                  l.get(keyWaterGiven),
                  houseAmount,
                  waterAmount,
                  mobile,
                  uid,
                  notifyTaxType);

              String subject =
                  "$name, $ud $uid, $taxPendingReceipt $dropdownValueYear";
              String body = """$notificationMessage

$findPendingReceipt

$regards,
$registeredName
""";
              String attachment = gReceiptPdfName;

              List<String> receipients = [
                email,
                adminMail,
              ];
              if (textMsgEnabled) {
                /*
                await sendTextToPhoneThoughTextLocal(
                    notificationMessage + "\n" + "-" + registeredName,
                    listMobile);
                    */
                //For english language content template approval,
                // Just to make viVilPower happy with branch name for brandname
                if (AppLocalizations.of(gContext)!.language == "English") {
                  await sendTextToPhone(
                      notificationMessage +
                          "\n" +
                          "-" +
                          registeredName +
                          " -PhlySoft",
                      listMobile);
                } else {
                  //for Marathi as other than branch name is allready approved by vi vilpower
                  await sendTextToPhone(
                      notificationMessage + "\n" + "-" + registeredName,
                      listMobile);
                }
              }

              await sendEmail(subject, body, receipients,
                  attachment); //send mail to user cc admin
////////*******************END sending mail************************/////
            },
            icon: Icon(
              Icons.notifications_active_outlined,
              color: Colors.red,
            ),
            tooltip: AppLocalizations.of(gContext)!.txtNotifyToPay,
          ),
        ),
      );
      /*
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
                notifyTaxType = AppLocalizations.of(gContext)!.txtTaxTypeHouse;
              } else {
                amount = l.get(keyWater).toString();
                notifyTaxType = AppLocalizations.of(gContext)!.txtTaxTypeWater;
              }
              String OnlinePaymentLink = "dummy link";
              String notificationMessage = '''$dear 
$name,
$mobile,
$ud-$uid.
$payOnline, 
$pending $notifyTaxType 
$taxAmount Rs. $amount 
$forYear $dropdownValueYear 
$toGram through link $OnlinePaymentLink'''; //who is reminding

              String mobileWhatsApp = l.get(keyMobile);
              List<String> listMobile = [mobileWhatsApp];
////////*******************START sending mail************************/////

              String subject = '''$name, 
$ud $uid,
$notifyTaxType 
$onlinePaymentLink 
$forYear- $dropdownValueYear''';

              String body = """$notificationMessage
$regards,
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
            tooltip: AppLocalizations.of(gContext)!.txtNotifyToPayOnline,
          ),
        ),
      );
      */
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
            /*
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingOnlinePayment,
                style: getStyle(actPending),
              ),
            ),
            */
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
            .orderBy(keyTotalTaxOtherThanWater, descending: false)
            .snapshots();
      } else if (orderType == AppLocalizations.of(gContext)!.txtHtoL) {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yearDropDownValue)
            .where(keyHouseGiven, isEqualTo: false)
            .orderBy(keyTotalTaxOtherThanWater, descending: true)
            .snapshots();
      } else {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yearDropDownValue)
            .where(keyHouseGiven, isEqualTo: false)
            .orderBy(keyTotalTaxOtherThanWater, descending: true)
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
          return Text(AppLocalizations.of(gContext)!.msgNoExpense);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(AppLocalizations.of(gContext)!.msgLoading);
        }

        return getInHouseWaterTable(context, snapshot);
      },
    );
  }
}
