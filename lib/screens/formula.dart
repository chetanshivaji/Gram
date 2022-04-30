import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/util.dart';
import 'package:money/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> updateYearWiseFormula(
    int newEntryAmount, String typeInOut, String inType) async {
  var formulaRef;
  //START create Formula in each year once
  formulaRef = FirebaseFirestore.instance
      .collection(village + pin)
      .doc(docMainDb)
      .collection(collFormula + dropdownValueYear)
      .doc(docCalcultion);

  await formulaRef.get().then(
    (value) async {
      if (value.exists) {
        //if already present get and update.
        int pendingHouse, collectedHouse, pendingWater, collectedWater;
        pendingHouse = collectedHouse = pendingWater = collectedWater = 0;

        var y = value.data();
        collectedHouse = y![keyYfCollectedHouse];
        pendingHouse = y![keyYfPendingHouse];
        collectedWater = y![keyYfCollectedWater];
        pendingWater = y![keyYfPendingWater];

        if (typeInOut == "in") {
          if (inType == txtTaxTypeHouse) {
            await formulaRef.update(
              {
                keyYfCollectedHouse: collectedHouse + newEntryAmount,
                keyYfPendingHouse: pendingHouse - newEntryAmount,
              },
            );
          } else {
            //water
            await formulaRef.update(
              {
                keyYfCollectedWater: collectedWater + newEntryAmount,
                keyYfPendingWater: pendingWater - newEntryAmount,
              },
            );
          }
        } else {
          //nothing as out is not in product
        }
      }
    },
  );
}

Future<void> updateFormulaValues(int newEntryAmount, String typeInOut) async {
  int total = await FirebaseFirestore.instance
      .collection(village + pin)
      .doc(docMainDb)
      .collection(collFormula)
      .doc(docCalcultion)
      .get()
      .then(
    (value) {
      var y = value.data();
      return (typeInOut == "in") ? y![keyTotalIn] : y![keyTotalOut];
    },
  );

  //update formula
  if (typeInOut == "in") {
    FirebaseFirestore.instance
        .collection(village + pin)
        .doc(docMainDb)
        .collection(collFormula)
        .doc(docCalcultion)
        .update(
      {
        keyTotalIn: (total + newEntryAmount),
      },
    );
  } else {
    FirebaseFirestore.instance
        .collection(village + pin)
        .doc(docMainDb)
        .collection(collFormula)
        .doc(docCalcultion)
        .update(
      {
        keyTotalOut: (total + newEntryAmount),
      },
    );
  }
}

Text getFormulaTextStyle(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  );
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
        getForumlaInternalSimple(txtFIn, totalIn.toString()),
        Text(
          " - ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
        getForumlaInternalSimple(txtFOut, totalOut.toString()),
        Text(
          equals,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          textAlign: TextAlign.end,
        ),
        getForumlaInternalSimple(txtFRemain, (totalIn - totalOut).toString()),
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
