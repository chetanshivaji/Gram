import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/constants.dart';
import 'package:intl/intl.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Locale gLocale = Locale('en');

late BuildContext gContext;
int totalIn = 0;
int totalOut = 0;
int totalBalance = 0;

String village = "";
String pin = "";
String registeredName = "";
String userMail = "";
String adminMail = "";
bool userApproved = false;

bool onPressedDrawerIn = false;
bool onPressedDrawerOut = false;
bool onPressedDrawerPending = false;
bool onPressedDrawerReport = false;

var myPdfTableCellFontStyle;
var myPdfTableHeaderFontStyle;

int access = accessLevel.No.index; //"No";
enum accessLevel {
  select,
  SuperUser,
  Viewer,
  Collector,
  Spender,
  No,
}
List<String> accessItems = [
  "select",
  "SuperUser",
  "Viewer",
  "Collector",
  "Spender",
  "No"
];

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

Future<int> getUserAccessLevel(BuildContext context, String email) async {
  try {
    int usreAccessLevel = await FirebaseFirestore.instance
        .collection(collUsers)
        .doc(email)
        .get()
        .then(
      (value) {
        var y = value.data();
        return y![keyAccessLevel];
      },
    );
    return usreAccessLevel;
  } catch (e) {
    popAlert(context, AppLocalizations.of(gContext)!.txtFetchFailFromDb, "",
        getWrongIcon(50.0), 1);
    return accessLevel.Viewer.index; //Return viewer by default
  }
}

Future<List<String>> getLoggedInUserVillagePin() async {
  List<String> lsVillagePin = [];
  String? email = FirebaseAuth.instance.currentUser!.email;
  String village = "";
  String pin = "";

  await FirebaseFirestore.instance.collection(collUsers).doc(email).get().then(
    (value) {
      var y = value.data();
      village = y![keyVillage];
      pin = y[keyPin];
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
    fontFamily: tableHeadingFontFamily,
  );
}

TextStyle getStyle(String type) {
  if (type == actIn) {
    return TextStyle(
      color: Colors.green[900],
    );
  } else if (type == actPending) {
    return TextStyle(
      color: Colors.amber[900],
    );
  } else {
    return TextStyle(
      color: Colors.red[900],
    );
  }
}

String getCurrentDateTimeInDHM() {
  DateTime now = DateTime.now();
  String dateYMDHM = DateFormat('yyyy-MM-dd kk:mm').format(now);
  return dateYMDHM;
}

Color getColor(String type) {
  if ((type == actIn) ||
      (type == collPrefixInHouse) ||
      (type == collPrefixInWater) ||
      (type == collPrefixInExtra)) {
    return Colors.green;
  } else if (type == actPending) {
    return Color(0xFFFF8F00); //Amber type
  } else {
    return Colors.red;
  }
}

ListTile getListTile(Icon leadingIcon, String lhs, String rhs) {
  return ListTile(
    minLeadingWidth: 0,
    leading: leadingIcon,
    title: getPrefilledListTile(lhs, rhs),
  );
}

Widget getPrefilledListTile(String LHS, String RHS) {
  return Row(
    children: [
      Text(
        "$LHS = ",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "$RHS",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.blue,
        ),
      ),
    ],
  );
}

TextStyle getTableFirstColStyle() {
  return TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
}

Image imgSuccess = Image.asset("assets/success.jpeg");

Icon getWrongIcon(double iconSize) {
  return Icon(
    Icons.cancel,
    size: iconSize,
    color: Colors.red,
  );
}

TableBorder getTableBorder() {
  return TableBorder(
    horizontalInside: BorderSide(
      width: 1,
      color: clrTableHorizontalBorder,
    ),
    verticalInside: BorderSide(
      width: 1,
      color: clrTableVerticleBorder,
    ),
  );
}

Icon getMultiUidIcon(double iconSize) {
  return Icon(
    Icons.multiple_stop,
    size: iconSize,
    color: Colors.blue,
  );
}

Icon getRightIcon(double iconSize) {
  return Icon(
    Icons.done,
    size: iconSize,
    color: Colors.green,
  );
}

int remainFormula = 0;
int inFormula = 0;
int outFormula = 0;

String dropdownValueYear = DateTime.now().year.toString();

var items = [
  "2019",
  "2020",
  "2021",
  "2022",
  "2023",
];

Widget getPadding() {
  return Padding(
    padding: EdgeInsets.only(top: 20),
  );
}

class yearTile extends StatefulWidget {
  Color clr = Colors.blue;
  yearTile({Key? key, this.clr = Colors.blue}) : super(key: key);

  @override
  _yearTileState createState() => _yearTileState();
}

class _yearTileState extends State<yearTile> {
  @override
  Widget build(BuildContext context) {
    gContext = context;
    return ListTile(
      trailing: DropdownButton(
        borderRadius: BorderRadius.circular(12.0),
        dropdownColor: widget.clr,

        alignment: Alignment.topLeft,

        // Initial Value
        value: dropdownValueYear,
        // Down Arrow Icon
        icon: Icon(
          Icons.date_range,
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

void popLogOutAlert(
    BuildContext context, String title, String subtitle, Widget imgRightWrong) {
  //shows alert dialog
  //paramaters, title, subtitle, imgRightWrong:image with right or wrong icon, popCount: how many times navigate back
  Widget cancelButton = TextButton(
    child: Text(AppLocalizations.of(gContext)!.optCancel),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget okButton = TextButton(
    child: Text(AppLocalizations.of(gContext)!.optOk),
    onPressed: () {
      FirebaseAuth.instance.signOut();
      Navigator.pop(context); //main screen of app
      Navigator.pop(context); //login or registeration screen
      Navigator.pop(context); //welcome screen
    },
  );

  AlertDialog alert = AlertDialog(
    content: submitPop(title, subtitle, imgRightWrong),
    actions: [
      cancelButton,
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

void popAlert(BuildContext context, String title, String subtitle,
    Widget imgRightWrong, int popCount) {
  //shows alert dialog
  //paramaters, title, subtitle, imgRightWrong:image with right or wrong icon, popCount: how many times navigate back

  Widget okButton = TextButton(
    child: Text(AppLocalizations.of(gContext)!.optOk),
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
  BuildContext context,
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
      body: ((pageName == actPending) || (pageName == actReport))
          ? (TabBarView(
              children: lsTabBarView,
            ))
          : SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height),
                child: Container(
                  child: TabBarView(
                    children: lsTabBarView,
                  ),
                ),
              ),
            ),
    ),
  );
}
