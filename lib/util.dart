import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/constants.dart';

int totalIn = 0;
int totalOut = 0;
int totalBalance = 0;

Color clrGreen = Color(0xFFc8e6c9); //in

Color clrRed = Color(0xffef9a9a); //out

Color clrAmber = Color(0xFFF7E5B4); //pending

Color clrBlue = Color(0xFF7E57E2); //report indigo;
String userMail = "";

TextStyle getTableHeadingTextStyle() {
  return TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    fontFamily: "RobotoMono",
  );
}

void updateFormulaValues(String newEntryAmount, String typeInOut) async {
  int total = await FirebaseFirestore.instance
      .collection(colletionName_forumla)
      .doc(documentName_formula)
      .get()
      .then((value) {
    var y = value.data();
    return (typeInOut == "in") ? y!["totalIn"] : y!["totalOut"];
  });

  //update formula
  if (typeInOut == "in") {
    FirebaseFirestore.instance
        .collection("formula")
        .doc("calculation")
        .update({'totalIn': (total + int.parse(newEntryAmount))});
  } else {
    FirebaseFirestore.instance
        .collection("formula")
        .doc("calculation")
        .update({'totalOut': (total + int.parse(newEntryAmount))});
  }
}

Text getFormulaTextStyle(String text) {
  return Text(text,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold));
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
Widget getForumlaInternalSimple(String type, String value) {
  return Column(
    children: <Widget>[
      Text(type),
      Divider(height: 2),
      Text(value),
    ],
  );
}

Widget formulaNew(int totalIn, int totalOut) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      children: <Widget>[
        getForumlaInternalSimple("In", totalIn.toString()),
        Text(
          " - ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
        getForumlaInternalSimple("Out", totalOut.toString()),
        Text(
          " = ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          textAlign: TextAlign.end,
        ),
        getForumlaInternalSimple("Remain", (totalIn - totalOut).toString()),
      ],
    ),
  );
}

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

void showAlertDialog(
    BuildContext context, String title, String subtitle, Widget img) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    //TODO: print success or failure and image, depending on processing
    content: submitPop(title, subtitle, img),
    actions: [
      cancelButton, //pops once return to same page
      continueButton, //pops twice returns to home page
    ],
  );
  // show the dialog
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
      backgroundColor: clr,
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
