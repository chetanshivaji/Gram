import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/constants.dart';

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
