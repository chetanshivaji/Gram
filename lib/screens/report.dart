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
  reportContainer({Key? key, this.reportType = collPrefixInHouse})
      : super(key: key);

  @override
  _reportContainerState createState() => _reportContainerState();
}

DateTime fromDate = DateTime.now();
DateTime toDate = DateTime.now();
String startDate = DateTime.now().day.toString() +
    "/" +
    DateTime.now().month.toString() +
    "/" +
    DateTime.now().year.toString();
String endDate = DateTime.now().day.toString() +
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
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));

    if (pickedDate != null && pickedDate != fromDate)
      setState(
        () {
          startDate = pickedDate.day.toString() +
              "/" +
              pickedDate.month.toString() +
              "/" +
              pickedDate.year.toString();
        },
      );
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));

    if (pickedDate != null && pickedDate != fromDate)
      setState(
        () {
          endDate = pickedDate.day.toString() +
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

    var snapshots;
    if (widget.reportType == collPrefixInHouse) {
      var collection = FirebaseFirestore.instance
          .collection(village + pin)
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
    } else if (widget.reportType == collPrefixInWater) {
      var collection = FirebaseFirestore.instance
          .collection(village + pin)
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
    } else if (widget.reportType == collPrefixInExtra) {
      var collection = FirebaseFirestore.instance
          .collection(village + pin)
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
    } else if (widget.reportType == collPrefixOut) {
      var collection = FirebaseFirestore.instance
          .collection(village + pin)
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
        await doc.reference.get().then(
          (value) {
            var y = value.data();
            switch (widget.reportType) {
              case collPrefixInHouse:
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

              case collPrefixInWater:
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
              case collPrefixInExtra:
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
              case collPrefixOut:
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
          },
        );
      } catch (e) {
        popAlert(
            context, kTitleTryCatchFail, e.toString(), getWrongIcon(50.0), 1);
      }
    }

    String taxType = "";
    var invoice;
    switch (widget.reportType) {
      case collPrefixInHouse:
        {
          taxType = txtTaxTypeHouse;
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

      case collPrefixInWater:
        {
          taxType = txtTaxTypeWater;
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

      case collPrefixInExtra:
        {
          taxType = collPrefixInExtra;
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

      case collPrefixOut:
        {
          taxType = collPrefixOut;
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
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    _selectStartDate(context);
                  },
                  child: Text("Start:$startDate"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    _selectEndDate(context);
                  },
                  child: Text("End:$endDate"),
                ),
              ),
              IconButton(
                splashColor: clrIconSpalsh,
                splashRadius: iconSplashRadius,
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
              SizedBox(
                width: 10.0,
              ),
              DropdownButton(
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
                  color: clrBlue,
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
              SizedBox(
                width: 10.0,
              ),
              DropdownButton(
                borderRadius: BorderRadius.circular(12.0),
                dropdownColor: clrBlue,

                alignment: Alignment.topRight,

                // Initial Value
                value: dropdownValueYear,
                // Down Arrow Icon
                icon: Icon(Icons.date_range, color: clrBlue),
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
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
          Expanded(
            child: (widget.reportType == collPrefixInHouse) ||
                    (widget.reportType == collPrefixInWater) ||
                    (widget.reportType == collPrefixInExtra)
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

  List<Icon> lsIcons = [
    Icon(Icons.home, color: Colors.black),
    Icon(Icons.water, color: Colors.black),
    Icon(Icons.foundation_outlined, color: Colors.black),
    Icon(Icons.outbond, color: Colors.black),
  ];
  List<Widget> lsWidget = <Widget>[];
  List<String> lsText = [
    txtTaxTypeHouse,
    txtTaxTypeWater,
    "Extra Income",
    collPrefixOut
  ];

  @override
  Widget build(BuildContext context) {
    lsWidget.add(
      Expanded(
        child: reportContainer(reportType: collPrefixInHouse),
      ),
    );
    lsWidget.add(
      Expanded(
        child: reportContainer(reportType: collPrefixInWater),
      ),
    );
    lsWidget.add(
      Expanded(
        child: reportContainer(reportType: collPrefixInExtra),
      ),
    );
    lsWidget.add(
      Expanded(
        child: reportContainer(reportType: collPrefixOut),
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
