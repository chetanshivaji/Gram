import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/util.dart';
import 'package:money/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> updateYearWiseFormula(int newEntryAmount, String typeInOut,
    String inType, int totalTaxOtherThanWater_beforeDiscountFine) async {
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
        int pendingHouse,
            collectedHouse,
            pendingWater,
            collectedWater,
            totalHouseAfterDiscountFine;
        pendingHouse = collectedHouse =
            pendingWater = collectedWater = totalHouseAfterDiscountFine = 0;

        var y = value.data();
        collectedHouse = y![keyYfCollectedHouse];
        totalHouseAfterDiscountFine = y![keyYfTotalHouseAfterDiscountFine];
        pendingHouse = y![keyYfPendingHouse];
        collectedWater = y![keyYfCollectedWater];
        pendingWater = y![keyYfPendingWater];

        if (typeInOut == txtInType) {
          if (inType == AppLocalizations.of(gContext)!.txtTaxTypeHouse) {
            await formulaRef.update(
              {
                keyYfCollectedHouse: collectedHouse + newEntryAmount,
                //First update pending house amount, remvoe beforeDisountFine value, add afterDiscountFine value.
                //then remove afterDiscountFine value to update pending house.
                keyYfPendingHouse: (pendingHouse -
                        totalTaxOtherThanWater_beforeDiscountFine +
                        newEntryAmount) -
                    newEntryAmount,
                keyYfTotalHouseAfterDiscountFine: totalHouseAfterDiscountFine -
                    totalTaxOtherThanWater_beforeDiscountFine +
                    newEntryAmount,
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
      return (typeInOut == txtInType) ? y![keyTotalIn] : y![keyTotalOut];
    },
  );

  //update formula
  if (typeInOut == txtInType) {
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
        getForumlaInternalSimple(
            AppLocalizations.of(gContext)!.txtFIn, totalIn.toString()),
        Text(
          " - ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
        getForumlaInternalSimple(
            AppLocalizations.of(gContext)!.txtFOut, totalOut.toString()),
        Text(
          equals,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          textAlign: TextAlign.end,
        ),
        getForumlaInternalSimple(AppLocalizations.of(gContext)!.txtFRemain,
            (totalIn - totalOut).toString()),
      ],
    ),
  );
}

class formulaLive extends StatelessWidget {
  formulaLive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    gContext = context;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(village + pin)
          .doc(docMainDb)
          .collection(collFormula)
          .snapshots(),
      //Async snapshot.data-> query snapshot.docs -> docuemnt snapshot,.data["key"]
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(AppLocalizations.of(gContext)!.msgNoExpense);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(AppLocalizations.of(gContext)!.msgLoading);
        }
        if (snapshot.data!.docs.isNotEmpty) {
          DocumentSnapshot ds = snapshot.data!.docs[0];
          inFormula = ds.get(keyTotalIn);
          outFormula = ds.get(keyTotalOut);
          remainFormula = inFormula - outFormula;
        }

        return formulaNew(
          inFormula,
          outFormula,
        );
      },
    );
  }
}
