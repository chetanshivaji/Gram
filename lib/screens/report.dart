import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'inList.dart';
import 'outList.dart';
import 'formula.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/model/invoice.dart';
import 'package:money/api/pdf_api.dart';
import 'package:money/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class reportContainer extends StatefulWidget {
  String reportType = "";
  reportContainer({Key? key, this.reportType = collPrefixInHouse})
      : super(key: key);

  @override
  _reportContainerState createState() => _reportContainerState();
}

DateTime fromDate = DateTime.now();
DateTime toDate = DateTime.now();

DateTime startDate = DateTime(int.parse(dropdownValueYear), 1, 1);
DateTime endDate = DateTime(int.parse(dropdownValueYear), 12, 31);

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
      initialDate: (DateTime.now().year.toString() == dropdownValueYear)
          ? DateTime.now()
          : DateTime(int.parse(dropdownValueYear), 1, 1),
      firstDate: DateTime(int.parse(dropdownValueYear), 1, 1),
      lastDate: DateTime(int.parse(dropdownValueYear) + 1, 1, 1),
    );

    if (pickedDate != null && pickedDate != fromDate)
      setState(
        () {
          startDate = pickedDate;
          endDate =
              pickedDate; //when start date is changed, automatically change end date to start date.
        },
      );
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: startDate,
        lastDate: DateTime(int.parse(dropdownValueYear) + 1, 1, 1));

    if (pickedDate != null && pickedDate != fromDate)
      setState(
        () {
          endDate = pickedDate;
        },
      );
  }

  Future<void> createPDFReportEntries() async {
    //START - fetch data to display in pdf
    List<houseWaterReportEntry> entriesHouseWater = [];
    List<extraIncomeReportEntry> entriesExtraIncome = [];
    List<outReportEntry> entriesOut = [];

    var snapshots;
    var collection = FirebaseFirestore.instance
        .collection(village + pin)
        .doc(docMainDb)
        .collection(
            widget.reportType + dropdownValueYear); //TODO: need to user where

    if (dropdownValueReportSort == txtLtoH) {
      snapshots = await collection.orderBy(keyAmount, descending: false).get();
    } else if (dropdownValueReportSort == txtHtoL) {
      snapshots = await collection.orderBy(keyAmount, descending: true).get();
    } else {
      snapshots = await collection.orderBy(keyDate, descending: true).get();
    }
    //check if fetched date is between start and end date.

    DateTime sd = DateTime.parse(
        startDate.subtract(const Duration(days: 1)).toString().split(' ')[0]);

    DateTime ed = DateTime.parse(
        endDate.add(const Duration(days: 1)).toString().split(' ')[0]);

    int srNo = 0;
    for (var doc in snapshots.docs) {
      srNo = srNo + 1;
      try {
        await doc.reference.get().then(
          (value) {
            var y = value.data();
            String dateFetched = y![keyDate];
            DateTime fd = DateTime.parse(dateFetched.split(' ')[0]);

            if (fd.isBefore(ed) && fd.isAfter(sd)) {
              switch (widget.reportType) {
                case collPrefixInHouse:
                  {
                    houseWaterReportEntry pe = houseWaterReportEntry(
                      srnum: srNo.toString(),
                      name: y![keyName],
                      mobile: y![keyMobile],
                      uid: y![keyUid],
                      amount: y![keyAmount].toString(),
                      date: y![keyDate],
                      user: y![keyRegisteredName],
                    );
                    entriesHouseWater.add(pe);

                    break;
                  }

                case collPrefixInWater:
                  {
                    houseWaterReportEntry pe = houseWaterReportEntry(
                      srnum: srNo.toString(),
                      name: y![keyName],
                      mobile: y![keyMobile],
                      uid: y![keyUid],
                      amount: y![keyAmount].toString(),
                      date: y![keyDate],
                      user: y![keyRegisteredName],
                    );
                    entriesHouseWater.add(pe);

                    break;
                  }
                case collPrefixInExtra:
                  {
                    extraIncomeReportEntry pe = extraIncomeReportEntry(
                      srnum: srNo.toString(),
                      amount: y![keyAmount].toString(),
                      reason: y![keyReason],
                      date: y![keyDate],
                      user: y![keyRegisteredName],
                    );
                    entriesExtraIncome.add(pe);

                    break;
                  }
                case collPrefixOut:
                  {
                    outReportEntry pe = outReportEntry(
                      srnum: srNo.toString(),
                      name: y![keyName],
                      reason: y![keyReason],
                      amount: y![keyAmount].toString(),
                      extraInfo: y![keyExtraInfo],
                      date: y![keyDate],
                      user: y![keyRegisteredName],
                    );
                    entriesOut.add(pe);
                    break;
                  }
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
        }
        break;
    }

    final pdfFile = await invoice.generate(actReport, registeredName,
        startDate.toString().split(' ')[0], endDate.toString().split(' ')[0]);
    await PdfApi.openFile(pdfFile);
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
                    await _selectStartDate(context);
                  },
                  child: Text("$txtStartDate:$startDate".split(' ')[0]),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await _selectEndDate(context);
                  },
                  child: Text("$txtEndDate:$endDate".split(' ')[0]),
                ),
              ),
              Expanded(
                child: IconButton(
                  splashColor: clrIconSpalsh,
                  splashRadius: iconSplashRadius,
                  alignment: Alignment.topRight,
                  onPressed: () async {
                    await createPDFReportEntries();
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
              ),
              Expanded(
                child: DropdownButton(
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
                  onChanged: (String? newValue) async {
                    setState(
                      () {
                        dropdownValueYear = newValue!;
                        startDate =
                            DateTime(int.parse(dropdownValueYear), 1, 1);
                        endDate =
                            DateTime(int.parse(dropdownValueYear), 12, 31);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: (widget.reportType == collPrefixInHouse) ||
                    (widget.reportType == collPrefixInWater) ||
                    (widget.reportType == collPrefixInExtra)
                ? inList(
                    sDate: "$startDate".split(' ')[0],
                    eDate: "$endDate".split(' ')[0],
                    yearDropDownValue: dropdownValueYear,
                    inType: widget.reportType,
                    orderType: dropdownValueReportSort)
                : outList(
                    sDate: "$startDate".split(' ')[0],
                    eDate: "$endDate".split(' ')[0],
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
    txtTaxTypeExtraIncome,
    collPrefixOut
  ];

  @override
  Widget build(BuildContext context) {
    gContext = context;
    onPressedDrawerReport = false;
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
      context,
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
