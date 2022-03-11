import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/util.dart';
import 'package:money/constants.dart';

void updateFormulaValues(String newEntryAmount, String typeInOut) async {
  var ls = await getLoggedInUserVillagePin();

  int total = await FirebaseFirestore.instance
      .collection(ls[0] + ls[1])
      .doc(docMainDb)
      .collection(collFormula)
      .doc(docCalcultion)
      .get()
      .then((value) {
    var y = value.data();
    return (typeInOut == "in") ? y![keyTotalIn] : y![keyTotalOut];
  });

  //update formula
  if (typeInOut == "in") {
    FirebaseFirestore.instance
        .collection(ls[0] + ls[1])
        .doc(docMainDb)
        .collection(collFormula)
        .doc(docCalcultion)
        .update({keyTotalIn: (total + int.parse(newEntryAmount))});
  } else {
    FirebaseFirestore.instance
        .collection(ls[0] + ls[1])
        .doc(docMainDb)
        .collection(collFormula)
        .doc(docCalcultion)
        .update({keyTotalOut: (total + int.parse(newEntryAmount))});
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
          equals,
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
      stream: FirebaseFirestore.instance
          .collection(village + pin)
          .doc(docMainDb)
          .collection(collFormula)
          .snapshots(),
      //Async snapshot.data-> query snapshot.docs -> docuemnt snapshot,.data["key"]
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(msgNoExpense);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(msgLoading);
        }

        DocumentSnapshot ds = snapshot.data!.docs[0];
        inFormula = ds.get(keyTotalIn);
        outFormula = ds.get(keyTotalOut);
        remainFormula = inFormula - outFormula;

        return formulaNew(
          ds.get(keyTotalIn),
          ds.get(keyTotalOut),
        );
      },
    );
  }
}
