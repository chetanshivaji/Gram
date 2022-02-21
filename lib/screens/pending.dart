import 'package:flutter/material.dart';
import 'package:money/util.dart';

class pendingMoney extends StatefulWidget {
  pendingMoney({Key? key}) : super(key: key);
  static String id = "pendingscreen";
  @override
  _pendingMoneyState createState() => _pendingMoneyState();
}

class _pendingMoneyState extends State<pendingMoney> {
  List<Icon> lsIcons = [
    Icon(Icons.home, color: Colors.black),
    Icon(Icons.water, color: Colors.black),
  ];
  List<Widget> lsWidget = <Widget>[];
  List<String> lsText = ["Home", "Water"];

  String pageName = "PENDING";

  var items = [
    'Date',
    'H to L',
    'L to H',
  ];
  String dropdownvalue = "Date";
  Widget pendingContainer(String ReportType) {
    return Container(
      width: double.infinity,
      color: Colors.grey[350],
      alignment: Alignment.topLeft,
      child: Row(
        children: <Widget>[
          Expanded(
            child: IconButton(
              onPressed: () {
                print(
                    "Download button pressed"); //TODO: later add functionality of download.
              },
              icon: Icon(
                Icons.download,
                size: 30.0,
              ),
              color: getColor(ReportType),
              tooltip: "Download Report",
            ),
          ),
          Expanded(
            child: DropdownButton(
              style: TextStyle(
                backgroundColor: getColor(ReportType),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    lsWidget.add(pendingContainer(pageName));
    lsWidget.add(pendingContainer(pageName));

    Widget infoIcon = Icon(Icons.info);
    return tabScffold(lsIcons.length, lsText, lsIcons, lsWidget, pageName,
        clrAmber, infoIcon);
  }
}
