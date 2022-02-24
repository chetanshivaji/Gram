import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class outList extends StatelessWidget {
  String outType = "";
  String orderType = "";
  outList({Key? key, this.outType = "out", this.orderType = "date"})
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
          .collection(outType)
          .orderBy('amount', descending: false)
          .snapshots();
    } else if (orderType == "H to L") {
      stm = FirebaseFirestore.instance
          .collection(outType)
          .orderBy('amount', descending: true)
          .snapshots();
    } else {
      stm = FirebaseFirestore.instance
          .collection(outType)
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

class inList extends StatelessWidget {
  String inType = "";
  String orderType = "";

  inList({Key? key, this.inType = "inHouse", this.orderType = "date"})
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
          .collection(inType)
          .orderBy('amount', descending: false)
          .snapshots();
    } else if (orderType == "H to L") {
      stm = FirebaseFirestore.instance
          .collection(inType)
          .orderBy('amount', descending: true)
          .snapshots();
    } else {
      stm = FirebaseFirestore.instance
          .collection(inType)
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

class reportContainer extends StatefulWidget {
  String reportType = "";
  reportContainer({Key? key, this.reportType = "inHouse"}) : super(key: key);

  @override
  _reportContainerState createState() => _reportContainerState();
}

DateTime fromDate = DateTime.now();
DateTime toDate = DateTime.now();
String sFromDate = DateTime.now().day.toString() +
    "/" +
    DateTime.now().month.toString() +
    "/" +
    DateTime.now().year.toString();
String sToDate = DateTime.now().day.toString() +
    "/" +
    DateTime.now().month.toString() +
    "/" +
    DateTime.now().year.toString();
String dropdownvalue = "Date";
var items = [
  'Date',
  'H to L',
  'L to H',
];

class _reportContainerState extends State<reportContainer> {
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));

    if (pickedDate != null && pickedDate != fromDate)
      setState(
        () {
          sFromDate = pickedDate!.day.toString() +
              "/" +
              pickedDate.month.toString() +
              "/" +
              pickedDate.year.toString();
        },
      );
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));

    if (pickedDate != null && pickedDate != fromDate)
      setState(
        () {
          sToDate = pickedDate!.day.toString() +
              "/" +
              pickedDate.month.toString() +
              "/" +
              pickedDate.year.toString();
        },
      );
  }

  @override
  Widget build(BuildContext context) {
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
                child: ElevatedButton(
                  onPressed: () async {
                    _selectFromDate(context);
                  },
                  child: Text("From:$sFromDate"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    _selectToDate(context);
                  },
                  child: Text("To:$sToDate"),
                ),
              ),
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
                  color: getColor(widget.reportType),
                  tooltip: "Download Report",
                ),
              ),
              Expanded(
                child: DropdownButton(
                  style: TextStyle(
                    backgroundColor: getColor(widget.reportType),
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
            child: (widget.reportType == "inHouse") ||
                    (widget.reportType == "inWater") ||
                    (widget.reportType == "inExtra")
                ? inList(inType: widget.reportType, orderType: dropdownvalue)
                : outList(outType: widget.reportType, orderType: dropdownvalue),
          ),
        ],
      ),
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

  // Initial Selected Value

  Future<void> _selectFromDate(BuildContext context) async {}

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != toDate)
      setState(() {
        sToDate = pickedDate.toString();
      });
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
        child: reportContainer(reportType: 'inHouse'),
      ),
    );
    lsWidget.add(
      Expanded(
        child: reportContainer(reportType: 'inWater'),
      ),
    );
    lsWidget.add(
      Expanded(
        child: reportContainer(reportType: 'inExtra'),
      ),
    );
    lsWidget.add(
      Expanded(
        child: reportContainer(reportType: 'out'),
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
