import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pendingList.dart';
import 'package:money/constants.dart';

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

class pendingMoney extends StatefulWidget {
  static String id = "pendingscreen";
  pendingMoney({Key? key}) : super(key: key);

  @override
  _pendingMoneyState createState() => _pendingMoneyState();
}

class _pendingMoneyState extends State<pendingMoney> {
  String pageName = "PENDING";
  var items = [
    'Date',
    'H to L',
    'L to H',
  ];
  // Initial Selected Value
  String dropdownvalue = "Date";

  Widget pendingContainer(String reportType) {
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
                  dropdownColor: clrAmber,

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
          Expanded(child: pendingList(year: dbYear, pendingType: reportType)),
        ],
      ),
    );
  }

  List<Icon> lsIcons = [
    Icon(Icons.home, color: Colors.black),
    Icon(Icons.water, color: Colors.black),
  ];
  List<Widget> lsWidget = <Widget>[];
  List<String> lsText = ["Home", "Water"];

  @override
  Widget build(BuildContext context) {
    lsWidget.add(
      Expanded(
        child: pendingContainer(housePendingType),
      ),
    );
    lsWidget.add(
      Expanded(
        child: pendingContainer(waterPendingType),
      ),
    );

    Widget formulaWidget = formulaLive();
    return tabScffold(
      lsIcons.length,
      lsText,
      lsIcons,
      lsWidget,
      pageName,
      clrAmber,
      formulaWidget,
    );
  }
}
