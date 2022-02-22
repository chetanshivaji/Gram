import 'package:flutter/material.dart';
import 'package:money/constants.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class pendingList extends StatelessWidget {
  String pendingType = "";
  String year = "";
  pendingList({Key? key, this.year = "mainDb2021", this.pendingType = "house"})
      : super(key: key);

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> docSnapshot) {
    List<DataRow> ldataRow = [];

    for (var l in docSnapshot) {
      List<DataCell> ldataCell = [];
      if (l.get(pendingType) == false) {
        ldataCell.add(DataCell(Text(l.get("name"))));
        ldataCell.add(DataCell(Text(l.get("mobile").toString())));
        if (pendingType == housePendingType) {
          ldataCell.add(DataCell(Text(l.get("house").toString())));
        } else {
          ldataCell.add(DataCell(Text(l.get("water").toString())));
        }

        ldataRow.add(DataRow(cells: ldataCell));
      }
    }
    return ldataRow;
  }

  DataTable getInHouseWaterTable(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return DataTable(
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
            'House',
            style: getStyle("PENDING"),
          ),
        ),
      ],
      rows: _buildList(context, snapshot.data!.docs),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(year).snapshots(),
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
