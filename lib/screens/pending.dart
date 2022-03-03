import 'package:flutter/material.dart';

import 'package:money/util.dart';
import 'pendingList.dart';
import 'package:money/model/invoice.dart';
import 'formula.dart';

import 'package:money/api/pdf_api.dart';
import 'package:money/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class pendingContainer extends StatefulWidget {
  String pendingType = "";
  pendingContainer({Key? key, this.pendingType = "houseGiven"})
      : super(key: key);

  @override
  _pendingContainerState createState() => _pendingContainerState();
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
String dropdownValuePendingSort = 'H to L';
var itemsSort = [
  'H to L',
  'L to H',
];

class _pendingContainerState extends State<pendingContainer> {
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));

    if (pickedDate != null && pickedDate != fromDate)
      setState(
        () {
          sFromDate = pickedDate.day.toString() +
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
          sToDate = pickedDate.day.toString() +
              "/" +
              pickedDate.month.toString() +
              "/" +
              pickedDate.year.toString();
        },
      );
  }

  void createPDFPendingEntries() async {
    //START - fetch data to display in pdf
    List<pendingEntry> entries = [];

    var snapshots;
    if (widget.pendingType == housePendingType) {
      var collection =
          FirebaseFirestore.instance.collection(dbYear + dropdownValueYear);

      if (dropdownValuePendingSort == "L to H") {
        snapshots = await collection.orderBy('house', descending: false).get();
      } else if (dropdownValuePendingSort == "H to L") {
        snapshots = await collection.orderBy('house', descending: true).get();
      } else {
        snapshots = await collection.orderBy('house', descending: true).get();
      }
    } else {
      var collection =
          FirebaseFirestore.instance.collection(dbYear + dropdownValueYear);

      if (dropdownValuePendingSort == "L to H") {
        snapshots = await collection.orderBy('water', descending: false).get();
      } else if (dropdownValuePendingSort == "H to L") {
        snapshots = await collection.orderBy('water', descending: true).get();
      } else {
        snapshots = await collection.orderBy('water', descending: true).get();
      }
    }

    for (var doc in snapshots.docs) {
      try {
        await doc.reference.get().then((value) {
          var y = value.data();
          pendingEntry pe = pendingEntry(
              name: y!["name"],
              mobile: y!["mobile"].toString(),
              amount: (widget.pendingType == housePendingType)
                  ? y!["house"].toString()
                  : y!["water"].toString());
          entries.add(pe);
        });
      } catch (e) {
        print(e);
      }
    }

    final invoice = pendingInvoice(
        info: InvoiceInfo(
            formula:
                'InMoney=$inFormula; OutMoney=$outFormula; RemainingMoney=$remainFormula',
            year: dropdownValueYear,
            sortingType: dropdownValuePendingSort,
            taxType:
                (widget.pendingType == housePendingType) ? "house" : "water"),
        pendingInvoiceItems: entries);

    final pdfFile = await invoice.generate("PENDING", userMail);

    PdfApi.openFile(pdfFile);
    //END - fetch data to display in pdf
  }

  //.where('waterGiven', isEqualTo: true)
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[350],
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              /*
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
              */
              Expanded(
                child: DropdownButton(
                  borderRadius: BorderRadius.circular(12.0),
                  dropdownColor: clrAmber,

                  alignment: Alignment.topLeft,

                  // Initial Value
                  value: dropdownValueYear,
                  // Down Arrow Icon
                  icon: Icon(
                    Icons.date_range,
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
                        dropdownValueYear = newValue!;
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  alignment: Alignment.topRight,
                  onPressed: () async {
                    //TODO: update pendingInvoiceItems from DB later.

                    createPDFPendingEntries();

                    print("Download button pressed");
                  },
                  icon: Icon(
                    Icons.download,
                    size: 30.0,
                  ),
                  color: getColor(widget.pendingType),
                  tooltip: "Download pending",
                ),
              ),
              Expanded(
                child: DropdownButton(
                  style: TextStyle(
                    backgroundColor: getColor(widget.pendingType),
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  dropdownColor: clrAmber,

                  alignment: Alignment.topRight,

                  // Initial Value
                  value: dropdownValuePendingSort,
                  // Down Arrow Icon
                  icon: Icon(
                    Icons.sort,
                  ),
                  // Array list of items
                  items: itemsSort.map(
                    (String itemsSort) {
                      return DropdownMenuItem(
                        value: itemsSort,
                        child: Text(itemsSort),
                      );
                    },
                  ).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        dropdownValuePendingSort = newValue!;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Expanded(
              child: pendingList(
                  yearDropDownValue: dropdownValueYear,
                  pendingType: widget.pendingType,
                  orderType: dropdownValuePendingSort)),
        ],
      ),
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
  ];
  List<Widget> lsWidget = <Widget>[];
  List<String> lsText = ["Home", "Water"];

  @override
  Widget build(BuildContext context) {
    lsWidget.add(
      Expanded(
        child: pendingContainer(pendingType: 'houseGiven'),
      ),
    );
    lsWidget.add(
      Expanded(
        child: pendingContainer(pendingType: 'waterGiven'),
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
