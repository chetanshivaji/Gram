import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'inList.dart';
import 'outList.dart';
import 'formula.dart';

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
String dropdownvalueReport = "Date";
var itemsSort = [
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
                  value: dropdownvalue,
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
                        dropdownvalue = newValue!;
                      },
                    );
                  },
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
                  value: dropdownvalueReport,
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
                        dropdownvalueReport = newValue!;
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
                    yearDropDownValue: dropdownvalue,
                    inType: widget.reportType,
                    orderType: dropdownvalueReport)
                : outList(
                    yearDropDownValue: dropdownvalue,
                    outType: widget.reportType,
                    orderType: dropdownvalueReport),
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
