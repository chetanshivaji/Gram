import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int totalIn = 0;
int totalOut = 0;
int totalBalance = 0;
String mainDb = "mainDb";
String village = "";
String pin = "";

Color clrGreen = Color(0xFFc8e6c9); //in

Color clrRed = Color(0xffef9a9a); //out

Color clrAmber = Color(0xFFF7E5B4); //pending

Color clrBlue = Color(0xFF7E57E2); //report indigo;
String userMail = "";

bool userApproved = false;
int userAccessLevel = 0;

Future<List<String>> getLoggedInUserVillagePin() async {
  List<String> lsVillagePin = [];
  String? email = FirebaseAuth.instance.currentUser!.email;
  String village = "";
  String pin = "";

  await FirebaseFirestore.instance.collection('users').doc(email).get().then(
    (value) {
      var y = value.data();
      village = y!['village'];
      pin = y['pin'];
      lsVillagePin.add(village);
      lsVillagePin.add(pin);
    },
  );
  return lsVillagePin;
}

TextStyle getTableHeadingTextStyle() {
  return TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    fontFamily: "RobotoMono",
  );
}

TextStyle getStyle(String type) {
  if (type == "IN") {
    return TextStyle(
      color: Colors.green[900],
    );
  } else if (type == "PENDING") {
    return TextStyle(
      color: Colors.amber[900],
    );
  } else {
    return TextStyle(
      color: Colors.red[900],
    );
  }
}

Color getColor(String type) {
  if ((type == "IN") ||
      (type == "inHouse") ||
      (type == "inWater") ||
      (type == "inExtra")) {
    return Colors.green;
  } else if (type == "PENDING") {
    return Color(0xFFFF8F00); //Amber type
  } else {
    return Colors.red;
  }
}

String titleSuccess = "Success";
String subtitleSuccess = "Submitted!";
Image imgSuccess = Image.asset("assets/success.jpeg");

Icon getWrongIcon() {
  return Icon(
    Icons.cancel,
    size: 50.0,
    color: Colors.red,
  );
}

Icon getRightIcon() {
  return Icon(
    Icons.done,
    size: 50.0,
    color: Colors.green,
  );
}

int remainFormula = 0;
int inFormula = 0;
int outFormula = 0;

String dropdownValueYear = "2021";

var items = [
  "2012",
  "2013",
  "2014",
  "2015",
  "2016",
  "2017",
  "2018",
  "2019",
  "2020",
  "2021",
  "2022",
];

class yearTile extends StatefulWidget {
  Color clr = Colors.blue;
  yearTile({Key? key, this.clr = Colors.blue}) : super(key: key);

  @override
  _yearTileState createState() => _yearTileState();
}

class _yearTileState extends State<yearTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.date_range),
      title: Text(
        "Year",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: DropdownButton(
        borderRadius: BorderRadius.circular(12.0),
        dropdownColor: widget.clr,

        alignment: Alignment.topLeft,

        // Initial Value
        value: dropdownValueYear,
        // Down Arrow Icon
        icon: Icon(
          Icons.sort,
          color: widget.clr,
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
    );
  }
}

void popAlert(BuildContext context, String title, String subtitle,
    Widget imgRightWrong, int popCount) {
  //shows alert dialog
  //paramaters, title, subtitle, imgRightWrong:image with right or wrong icon, popCount: how many times navigate back

  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      for (int i = 0; i < popCount; i++) {
        Navigator.pop(context);
      }
    },
  );

  AlertDialog alert = AlertDialog(
    content: submitPop(title, subtitle, imgRightWrong),
    actions: [
      okButton, //pops twice returns to home page
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget submitPop(String res, String info, Widget childWid) {
  return ListTile(
    leading: childWid,
    title: Text(res),
    subtitle: Text(info),
  );
}

Widget tabScffold(
  int len,
  List<String> tabText,
  List<Icon> tabIcon,
  List<Widget> tabBody,
  String pageName,
  Color clr,
  Widget extraWidget,
) {
  List<Tab> lsTabs = [];
  List<Widget> lsTabBarView = [];

  for (int i = 0; i < len; i++) {
    lsTabs.add(
      Tab(
        child: Column(
          children: [
            Text(
              tabText[i],
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            tabIcon[i]
          ],
        ),
      ),
    );
    lsTabBarView.add(
      tabBody[i],
    );
  }
  return DefaultTabController(
    length: len,
    child: Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          tabs: lsTabs,
          indicatorWeight: 4.0,
        ),
        backgroundColor: clr,
        title: Text(
          pageName,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[extraWidget],
      ),
      body: TabBarView(
        children: lsTabBarView,
      ),
    ),
  );
}

/*
import 'package:intl/intl.dart';

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}
*/