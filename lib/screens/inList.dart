import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class inList extends StatelessWidget {
  String inType = "";
  String orderType = "";
  String yearDropDownValue = "";

  inList(
      {Key? key,
      this.yearDropDownValue = "2021",
      this.inType = "inHouse",
      this.orderType = "date"})
      : super(key: key);

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> docSnapshot) {
    List<DataRow> ldataRow = [];

    for (var l in docSnapshot) {
      List<DataCell> ldataCell = [];
      if (inType == "inExtra") {
        ldataCell.add(DataCell(Text(l.get("amount").toString())));
        ldataCell.add(DataCell(Text(l.get("reason"))));
        ldataCell.add(DataCell(Text(l.get("date"))));
        ldataCell.add(DataCell(Text(l.get("user"))));
      } else {
        ldataCell.add(DataCell(Text(l.get("name"))));
        ldataCell.add(DataCell(Text(l.get("mobile"))));
        ldataCell.add(DataCell(Text(l.get("amount").toString())));
        ldataCell.add(DataCell(Text(l.get("date"))));
        ldataCell.add(DataCell(Text(l.get("user"))));
      }

      ldataRow.add(DataRow(cells: ldataCell));
    }
    return ldataRow;
  }

  SingleChildScrollView getInExtraTable(
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
                'Amount',
                style: getStyle("IN"),
              ),
            ),
            DataColumn(
              label: Text(
                'Reason',
                style: getStyle("IN"),
              ),
            ),
            DataColumn(
              label: Text(
                'Date',
                style: getStyle("IN"),
              ),
            ),
            DataColumn(
              label: Text(
                'User',
                style: getStyle("IN"),
              ),
            ),
          ],
          rows: _buildList(context, snapshot.data!.docs),
        ),
      ),
    );
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
                style: getStyle("IN"),
              ),
            ),
            DataColumn(
              label: Text(
                'Mobile',
                style: getStyle("IN"),
              ),
            ),
            DataColumn(
              label: Text(
                'Amount',
                style: getStyle("IN"),
              ),
            ),
            DataColumn(
              label: Text(
                'Date',
                style: getStyle("IN"),
              ),
            ),
            DataColumn(
              label: Text(
                'User',
                style: getStyle("IN"),
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
    if (orderType == "L to H") {
      stm = FirebaseFirestore.instance
          .collection(inType + yearDropDownValue)
          .orderBy('amount', descending: false)
          .snapshots();
    } else if (orderType == "H to L") {
      stm = FirebaseFirestore.instance
          .collection(inType + yearDropDownValue)
          .orderBy('amount', descending: true)
          .snapshots();
    } else {
      stm = FirebaseFirestore.instance
          .collection(inType + yearDropDownValue)
          .orderBy('date', descending: true)
          .snapshots();
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

        return (inType == "inExtra")
            ? getInExtraTable(context, snapshot)
            : getInHouseWaterTable(context, snapshot);
      },
    );
  }
}
