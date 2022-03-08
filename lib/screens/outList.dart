import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'inList.dart';

class outList extends StatelessWidget {
  String outType = "";
  String orderType = "";
  String yearDropDownValue = "";

  outList(
      {Key? key,
      this.yearDropDownValue = "2021",
      this.outType = "out",
      this.orderType = "date"})
      : super(key: key);

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> docSnapshot) {
    List<DataRow> ldataRow = [];

    for (var l in docSnapshot) {
      List<DataCell> ldataCell = [];
      ldataCell.add(DataCell(Text(l.get("name"))));
      ldataCell.add(DataCell(Text(l.get("reason"))));
      ldataCell.add(DataCell(Text(l.get("amount").toString())));
      ldataCell.add(DataCell(Text(l.get("extraInfo"))));
      ldataCell.add(DataCell(Text(l.get("date"))));
      ldataCell.add(DataCell(Text(l.get("user"))));

      ldataRow.add(DataRow(cells: ldataCell));
    }
    return ldataRow;
  }

  SingleChildScrollView getOutTable(
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
                style: getStyle("OUT"),
              ),
            ),
            DataColumn(
              label: Text(
                'Reason',
                style: getStyle("OUT"),
              ),
            ),
            DataColumn(
              label: Text(
                'Amount',
                style: getStyle("OUT"),
              ),
            ),
            DataColumn(
              label: Text(
                'ExtraInfo',
                style: getStyle("OUT"),
              ),
            ),
            DataColumn(
              label: Text(
                'Date',
                style: getStyle("OUT"),
              ),
            ),
            DataColumn(
              label: Text(
                'User',
                style: getStyle("OUT"),
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
          .collection(village + pin)
          .doc(mainDb)
          .collection(outType + yearDropDownValue)
          .orderBy('amount', descending: false)
          .snapshots();
    } else if (orderType == "H to L") {
      stm = FirebaseFirestore.instance
          .collection(village + pin)
          .doc(mainDb)
          .collection(outType + yearDropDownValue)
          .orderBy('amount', descending: true)
          .snapshots();
    } else {
      stm = FirebaseFirestore.instance
          .collection(village + pin)
          .doc(mainDb)
          .collection(outType + yearDropDownValue)
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

        return getOutTable(context, snapshot);
      },
    );
  }
}
