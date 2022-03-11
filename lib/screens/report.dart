import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'inList.dart';
import 'outList.dart';
import 'formula.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/model/invoice.dart';
import 'package:money/api/pdf_api.dart';
import 'package:money/constants.dart';

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
String dropdownValueReportSort = "Date";
var itemsSort = [
  tableHeadingDate,
  txtHtoL,
  txtLtoH,
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

  void createPDFReportEntries() async {
    //START - fetch data to display in pdf
    List<houseWaterReportEntry> entriesHouseWater = [];
    List<extraIncomeReportEntry> entriesExtraIncome = [];
    List<outReportEntry> entriesOut = [];
    var ls = await getLoggedInUserVillagePin();
    var snapshots;
    if (widget.reportType == "inHouse") {
      var collection = FirebaseFirestore.instance
          .collection(ls[0] + ls[1])
          .doc(docMainDb)
          .collection(
              widget.reportType + dropdownValueYear); //TODO: need to user where

      if (dropdownValueReportSort == txtLtoH) {
        snapshots =
            await collection.orderBy(keyAmount, descending: false).get();
      } else if (dropdownValueReportSort == txtHtoL) {
        snapshots = await collection.orderBy(keyAmount, descending: true).get();
      } else {
        snapshots = await collection.orderBy(keyAmount, descending: true).get();
      }
    } else if (widget.reportType == "inWater") {
      var collection = FirebaseFirestore.instance
          .collection(ls[0] + ls[1])
          .doc(docMainDb)
          .collection(widget.reportType + dropdownValueYear);

      if (dropdownValueReportSort == txtLtoH) {
        snapshots =
            await collection.orderBy(keyAmount, descending: false).get();
      } else if (dropdownValueReportSort == txtHtoL) {
        snapshots = await collection.orderBy(keyAmount, descending: true).get();
      } else {
        snapshots = await collection.orderBy(keyAmount, descending: true).get();
      }
    } else if (widget.reportType == "inExtra") {
      var collection = FirebaseFirestore.instance
          .collection(ls[0] + ls[1])
          .doc(docMainDb)
          .collection(widget.reportType + dropdownValueYear);

      if (dropdownValueReportSort == txtLtoH) {
        snapshots =
            await collection.orderBy(keyAmount, descending: false).get();
      } else if (dropdownValueReportSort == txtHtoL) {
        snapshots = await collection.orderBy(keyAmount, descending: true).get();
      } else {
        snapshots = await collection.orderBy(keyAmount, descending: true).get();
      }
    } else if (widget.reportType == "out") {
      var collection = FirebaseFirestore.instance
          .collection(ls[0] + ls[1])
          .doc(docMainDb)
          .collection(widget.reportType + dropdownValueYear);

      if (dropdownValueReportSort == txtLtoH) {
        snapshots =
            await collection.orderBy(keyAmount, descending: false).get();
      } else if (dropdownValueReportSort == txtHtoL) {
        snapshots = await collection.orderBy(keyAmount, descending: true).get();
      } else {
        snapshots = await collection.orderBy(keyAmount, descending: true).get();
      }
    }

    for (var doc in snapshots.docs) {
      try {
        await doc.reference.get().then((value) {
          var y = value.data();
          switch (widget.reportType) {
            case "inHouse":
              {
                houseWaterReportEntry pe = houseWaterReportEntry(
                  name: y![keyName],
                  mobile: y![keyMobile].toString(),
                  amount: y![keyAmount].toString(),
                  date: y![keyDate],
                  user: y![keyUser],
                );
                entriesHouseWater.add(pe);

                break;
              }

            case "inWater":
              {
                houseWaterReportEntry pe = houseWaterReportEntry(
                  name: y![keyName],
                  mobile: y![keyMobile].toString(),
                  amount: y![keyAmount].toString(),
                  date: y![keyDate],
                  user: y![keyUser],
                );
                entriesHouseWater.add(pe);

                break;
              }
            case "inExtra":
              {
                extraIncomeReportEntry pe = extraIncomeReportEntry(
                  amount: y![keyAmount].toString(),
                  reason: y![keyReason],
                  date: y![keyDate],
                  user: y![keyUser],
                );
                entriesExtraIncome.add(pe);

                break;
              }
            case "out":
              {
                outReportEntry pe = outReportEntry(
                  name: y![keyName],
                  reason: y![keyReason],
                  amount: y![keyAmount].toString(),
                  extraInfo: y![keyExtraInfo],
                  date: y![keyDate],
                  user: y![keyUser],
                );
                entriesOut.add(pe);
                break;
              }
          }
        });
      } catch (e) {
        print(e);
      }
    }

    String taxType = "";
    var invoice;
    switch (widget.reportType) {
      case "inHouse":
        {
          taxType = "House";
          invoice = reportHouseWaterInvoice(
              info: InvoiceInfo(
                formula:
                    '$txtForumlaIn$equals$inFormula; $txtForumlaOut$equals$outFormula; $txtForumlaRemain$equals$remainFormula',
                year: dropdownValueYear,
                sortingType: dropdownValueReportSort,
                taxType: taxType,
              ),
              houseWaterReportInvoiceItems: entriesHouseWater);
          break;
        }

      case "inWater":
        {
          taxType = "Water";
          invoice = reportHouseWaterInvoice(
              info: InvoiceInfo(
                formula:
                    '$txtForumlaIn$equals$inFormula; $txtForumlaOut$equals$outFormula; $txtForumlaRemain$equals$remainFormula',
                year: dropdownValueYear,
                sortingType: dropdownValueReportSort,
                taxType: taxType,
              ),
              houseWaterReportInvoiceItems: entriesHouseWater);
          break;
        }

      case "inExtra":
        {
          taxType = "InExtra";
          invoice = reportExtraInvoice(
              info: InvoiceInfo(
                formula:
                    '$txtForumlaIn$equals$inFormula; $txtForumlaOut$equals$outFormula; $txtForumlaRemain$equals$remainFormula',
                year: dropdownValueYear,
                sortingType: dropdownValueReportSort,
                taxType: taxType,
              ),
              extraIncomeReportInvoiceItems: entriesExtraIncome);

          break;
        }

      case "out":
        {
          taxType = "Out";
          invoice = reportOutInvoice(
              info: InvoiceInfo(
                formula:
                    '$txtForumlaIn$equals$inFormula; $txtForumlaOut$equals$outFormula; $txtForumlaRemain$equals$remainFormula',
                year: dropdownValueYear,
                sortingType: dropdownValueReportSort,
                taxType: taxType,
              ),
              outReportInvoiceItems: entriesOut);
          break;
        }

      default:
        {
          taxType = "InvalidSomethingWrong";
          ;
        }
        break;
    }

    final pdfFile = await invoice.generate(actReport, userMail);
    PdfApi.openFile(pdfFile);
    //END - fetch data to display in pdf
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
                    createPDFReportEntries();
                  },
                  icon: Icon(
                    Icons.download,
                    size: 30.0,
                  ),
                  color: getColor(widget.reportType),
                  tooltip: txtDownloadReport,
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
                  value: dropdownValueReportSort,
                  // Down Arrow Icon
                  icon: Icon(
                    Icons.sort,
                    color: Colors.blue,
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
                        dropdownValueReportSort = newValue!;
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
                ? inList(
                    yearDropDownValue: dropdownValueYear,
                    inType: widget.reportType,
                    orderType: dropdownValueReportSort)
                : outList(
                    yearDropDownValue: dropdownValueYear,
                    outType: widget.reportType,
                    orderType: dropdownValueReportSort),
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
  String pageName = actReport;

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
