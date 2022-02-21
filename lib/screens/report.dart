import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class outList extends StatelessWidget {
  String outType = "";
  outList({Key? key, this.outType = "out"}) : super(key: key);

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> docSnapshot) {
    List<DataRow> ldataRow = [];

    for (var l in docSnapshot) {
      List<DataCell> ldataCell = [];
      ldataCell.add(DataCell(Text(l.get("name"))));
      ldataCell.add(DataCell(Text(l.get("reason"))));
      ldataCell.add(DataCell(Text(l.get("amount"))));
      ldataCell.add(DataCell(Text(l.get("extraInfo"))));
      ldataCell.add(DataCell(Text(l.get("date"))));
      ldataCell.add(DataCell(Text(l.get("user"))));

      ldataRow.add(DataRow(cells: ldataCell));
    }
    return ldataRow;
  }

  DataTable getOutTable(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(outType).snapshots(),
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

class inList extends StatelessWidget {
  String inType = "";
  inList({Key? key, this.inType = "inHouse"}) : super(key: key);

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> docSnapshot) {
    List<DataRow> ldataRow = [];

    for (var l in docSnapshot) {
      List<DataCell> ldataCell = [];
      if (inType == "inExtra") {
        ldataCell.add(DataCell(Text(l.get("amount"))));
        ldataCell.add(DataCell(Text(l.get("reason"))));
        ldataCell.add(DataCell(Text(l.get("date"))));
        ldataCell.add(DataCell(Text(l.get("user"))));
      } else {
        ldataCell.add(DataCell(Text(l.get("name"))));
        ldataCell.add(DataCell(Text(l.get("mobile"))));
        ldataCell.add(DataCell(Text(l.get("tax"))));
        ldataCell.add(DataCell(Text(l.get("date"))));
        ldataCell.add(DataCell(Text(l.get("user"))));
      }

      ldataRow.add(DataRow(cells: ldataCell));
    }
    return ldataRow;
  }

  DataTable getInExtraTable(
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
    );
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
            'Tax',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(inType).snapshots(),
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

class formulaLive extends StatelessWidget {
  formulaLive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("formula").snapshots(),
      //Async snapshot.data-> query snapshot.docs -> docuemnt snapshot,.data["key"]
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("There is no expense");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("loading...");
        }

        DocumentSnapshot ds = snapshot.data!.docs[0];
        return formulaNew(
          ds.get("totalIn"),
          ds.get("totalOut"),
        );
      },
    );
  }
}

class reportMoney extends StatefulWidget {
  static String id = "reportscreen";
  reportMoney({Key? key}) : super(key: key);

  @override
  _reportMoneyState createState() => _reportMoneyState();
}

class _reportMoneyState extends State<reportMoney> {
  String pageName = "REPORT";
  var items = [
    'Date',
    'H to L',
    'L to H',
  ];
  // Initial Selected Value
  String dropdownvalue = "Date";

  Widget reportContainer(String reportType) {
    return Container(
      width: double.infinity,
      color: Colors.grey[350],
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: IconButton(
                  alignment: Alignment.topRight,
                  onPressed: () {
                    print(
                        "Download button pressed"); //TODO: later add functionality of download.
                  },
                  icon: Icon(
                    Icons.download,
                    size: 30.0,
                  ),
                  color: getColor(reportType),
                  tooltip: "Download Report",
                ),
              ),
              Expanded(
                child: DropdownButton(
                  style: TextStyle(
                    backgroundColor: getColor(reportType),
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  dropdownColor: clrBlue,

                  alignment: Alignment.topRight,

                  // Initial Value
                  value: dropdownvalue,
                  // Down Arrow Icon
                  icon: Icon(
                    Icons.sort,
                    color: Colors.blue,
                  ),
                  // Array list of items
                  items: items.map(
                    (String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    },
                  ).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        dropdownvalue = newValue!;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: (reportType == "inHouse") ||
                    (reportType == "inWater") ||
                    (reportType == "inExtra")
                ? inList(inType: reportType)
                : outList(outType: reportType),
          ),
        ],
      ),
    );
  }

  List<Icon> lsIcons = [
    Icon(Icons.home, color: Colors.black),
    Icon(Icons.water, color: Colors.black),
    Icon(Icons.foundation_outlined, color: Colors.black),
    Icon(Icons.outbond, color: Colors.black),
  ];
  List<Widget> lsWidget = <Widget>[];
  List<String> lsText = ["Home", "Water", "Extra Income", "Out"];

  @override
  Widget build(BuildContext context) {
    lsWidget.add(
      Expanded(
        child: reportContainer('inHouse'),
      ),
    );
    lsWidget.add(
      Expanded(
        child: reportContainer('inWater'),
      ),
    );
    lsWidget.add(
      Expanded(
        child: reportContainer('inExtra'),
      ),
    );
    lsWidget.add(
      Expanded(
        child: reportContainer('out'),
      ),
    );

    Widget formulaWidget = formulaLive();
    return tabScffold(
      lsIcons.length,
      lsText,
      lsIcons,
      lsWidget,
      pageName,
      clrBlue,
      formulaWidget,
    );
  }
}
