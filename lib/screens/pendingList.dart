import 'package:flutter/material.dart';
import 'package:money/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/util.dart';
import 'package:money/communication.dart';
import 'package:money/constants.dart';

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

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> docSnapshot) {
    List<DataRow> ldataRow = [];

    for (var l in docSnapshot) {
      List<DataCell> ldataCell = [];

      ldataCell.add(DataCell(Text(l.get(keyName))));
      ldataCell.add(DataCell(Text(l.get(keyMobile).toString())));
      if (pendingType == housePendingType) {
        ldataCell.add(DataCell(Text(l.get(keyHouse).toString())));
      } else {
        ldataCell.add(DataCell(Text(l.get(keyWater).toString())));
      }
      ldataCell.add(
        DataCell(
          IconButton(
            onPressed: () async {
              String name = l.get(keyName);
              String mobile = l.get(keyMobile).toString();
              String amount = "";
              String notifyTaxType = "";
              if (pendingType == housePendingType) {
                amount = l.get(keyHouse).toString();
                notifyTaxType = "House Tax";
              } else {
                amount = l.get(keyWater).toString();
                notifyTaxType = "Water Tax";
              }

              String notificationMessage =
                  "Dear $name,$mobile Reminder notice - please pay pending $notifyTaxType amount $amount to Grampanchayat  -- $userMail"; //who is reminding
              String mobileWhatsApp = l.get(keyMobile).toString();
              List<String> listMobile = [mobileWhatsApp];
              if (textMsgEnabled)
                await sendTextToPhone(notificationMessage, listMobile);

              if (whatsUpEnabled) if (mobileWhatsApp.contains("+91")) {
                await launchWhatsApp(
                    notificationMessage, "+91" + mobileWhatsApp);
              } else {
                //For foreign numbers stored, and phone numbers directly with country extension.
                await launchWhatsApp(notificationMessage, mobileWhatsApp);
              }
            },
            icon: Icon(
              Icons.notifications_active_outlined,
              color: Colors.red,
            ),
            splashColor: Colors.blue,
            tooltip: txtNotifyToPay,
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
          border: TableBorder(
            horizontalInside: BorderSide(
              width: 1.5,
              color: Colors.black,
            ),
          ),
          dataTextStyle: TextStyle(
            color: Colors.indigoAccent,
          ),
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                tableHeadingName,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                tableHeadingMobile,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                tableHeadingAmount,
                style: getStyle(actPending),
              ),
            ),
            DataColumn(
              label: Text(
                tableHeadingNotify,
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
    Stream<QuerySnapshot<Object?>> stm;
    if (pendingType == housePendingType) {
      if (orderType == txtLtoH) {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yearDropDownValue)
            .where(keyHouseGiven, isEqualTo: false)
            .orderBy(keyHouse, descending: false)
            .snapshots();
      } else if (orderType == txtHtoL) {
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
      if (orderType == txtLtoH) {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yearDropDownValue)
            .where(keyWaterGiven, isEqualTo: false)
            .orderBy(keyWater, descending: false)
            .snapshots();
      } else if (orderType == txtHtoL) {
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
