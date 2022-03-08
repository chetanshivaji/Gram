import 'package:flutter/material.dart';
import 'package:money/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/util.dart';
import 'package:money/communication.dart';

class pendingList extends StatelessWidget {
  String pendingType = "";
  String orderType = "";
  String yearDropDownValue = "";

  pendingList(
      {Key? key,
      this.yearDropDownValue = "2021",
      this.pendingType = "houseGiven",
      this.orderType = "date"})
      : super(key: key);

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> docSnapshot) {
    List<DataRow> ldataRow = [];

    for (var l in docSnapshot) {
      List<DataCell> ldataCell = [];

      ldataCell.add(DataCell(Text(l.get("name"))));
      ldataCell.add(DataCell(Text(l.get("mobile").toString())));
      if (pendingType == housePendingType) {
        ldataCell.add(DataCell(Text(l.get("house").toString())));
      } else {
        ldataCell.add(DataCell(Text(l.get("water").toString())));
      }
      ldataCell.add(
        DataCell(
          IconButton(
            onPressed: () async {
              String name = l.get("name");
              String mobile = l.get("mobile").toString();
              String amount = "";
              String notifyTaxType = "";
              if (pendingType == housePendingType) {
                amount = l.get("house").toString();
                notifyTaxType = "House Tax";
              } else {
                amount = l.get("water").toString();
                notifyTaxType = "Water Tax";
              }

              String notificationMessage =
                  "Dear $name,$mobile Reminder notice - please pay pending $notifyTaxType amount $amount to Grampanchayat";
              String mobileWhatsApp = l.get("mobile").toString();
              List<String> listMobile = [mobileWhatsApp];
              if (textMsgEnabled)
                await sendTextToPhone(notificationMessage, listMobile);

              if (whatsUpEnabled)
                await launchWhatsApp(
                    notificationMessage, "+91" + mobileWhatsApp);
            },
            icon: Icon(
              Icons.notifications_active_outlined,
              color: Colors.red,
            ),
            splashColor: Colors.blue,
            tooltip: "Send notification to Pay",
          ),
        ),
      );
      ldataRow.add(DataRow(cells: ldataCell));
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
          columnSpacing: 5.0,
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
                'Name',
                style: getStyle("PENDING"),
              ),
            ),
            DataColumn(
              label: Text(
                'Mobile',
                style: getStyle("PENDING"),
              ),
            ),
            DataColumn(
              label: Text(
                'Amount',
                style: getStyle("PENDING"),
              ),
            ),
            DataColumn(
              label: Text(
                'Notify',
                style: getStyle("PENDING"),
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
      if (orderType == "L to H") {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(mainDb)
            .collection(dbYearPrefix + yearDropDownValue)
            //.where('houseGiven', isEqualTo: false)
            .orderBy('house', descending: false)
            .snapshots();
      } else if (orderType == "H to L") {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(mainDb)
            .collection(dbYearPrefix + yearDropDownValue)
            //.where('houseGiven', isEqualTo: false)
            .orderBy('house', descending: true)
            .snapshots();
      } else {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(mainDb)
            .collection(dbYearPrefix + yearDropDownValue)
            //.where('houseGiven', isEqualTo: false)
            .orderBy('house', descending: true)
            .snapshots();
      }
    } else {
      if (orderType == "L to H") {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(mainDb)
            .collection(dbYearPrefix + yearDropDownValue)
            //.where('waterGiven', isEqualTo: false)
            .orderBy('water', descending: false)
            .snapshots();
      } else if (orderType == "H to L") {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(mainDb)
            .collection(dbYearPrefix + yearDropDownValue)
            //.where('waterGiven', isEqualTo: false)
            .orderBy('water', descending: true)
            .snapshots();
      } else {
        stm = FirebaseFirestore.instance
            .collection(village + pin)
            .doc(mainDb)
            .collection(dbYearPrefix + yearDropDownValue)
            //.where('waterGiven', isEqualTo: false)
            .orderBy('water', descending: true)
            .snapshots();
      }
    }

    return StreamBuilder<QuerySnapshot>(
      stream: stm,
      //Async snapshot.data-> query snapshot.docs -> docuemnt snapshot,.data["key"]
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("There is no expense");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("loading");
        }

        return getInHouseWaterTable(context, snapshot);
      },
    );
  }
}
