import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'pendingList.dart';
import 'package:money/model/invoice.dart';
import 'package:money/api/pdf_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class pendingContainer extends StatefulWidget {
  String pendingType = "";
  pendingContainer({Key? key, this.pendingType = keyHouseGiven})
      : super(key: key);

  @override
  _pendingContainerState createState() => _pendingContainerState();
}

String dropdownValuePendingSort = AppLocalizations.of(gContext)!.txtHtoL;
var itemsSort = [
  AppLocalizations.of(gContext)!.txtHtoL,
  AppLocalizations.of(gContext)!.txtLtoH,
];

class _pendingContainerState extends State<pendingContainer> {
  Future<void> createPDFPendingEntries() async {
    //START - fetch data to display in pdf
    List<pendingEntry> entries = [];

    var snapshots;
    if (widget.pendingType == housePendingType) {
      var collection = FirebaseFirestore.instance
          .collection(village + pin)
          .doc(docMainDb)
          .collection(docMainDb + dropdownValueYear);

      if (dropdownValuePendingSort == AppLocalizations.of(gContext)!.txtLtoH) {
        snapshots = await collection
            .where(keyHouseGiven, isEqualTo: false)
            .orderBy(keyHouse, descending: false)
            .get();
      } else if (dropdownValuePendingSort ==
          AppLocalizations.of(gContext)!.txtHtoL) {
        snapshots = await collection
            .where(keyHouseGiven, isEqualTo: false)
            .orderBy(keyHouse, descending: true)
            .get();
      } else {
        snapshots = await collection
            .where(keyHouseGiven, isEqualTo: false)
            .orderBy(keyHouse, descending: true)
            .get();
      }
    } else {
      var collection = FirebaseFirestore.instance
          .collection(village + pin)
          .doc(docMainDb)
          .collection(docMainDb + dropdownValueYear);

      if (dropdownValuePendingSort == AppLocalizations.of(gContext)!.txtLtoH) {
        snapshots = await collection
            .where(keyWaterGiven, isEqualTo: false)
            .orderBy(keyWater, descending: false)
            .get();
      } else if (dropdownValuePendingSort ==
          AppLocalizations.of(gContext)!.txtHtoL) {
        snapshots = await collection
            .where(keyWaterGiven, isEqualTo: false)
            .orderBy(keyWater, descending: true)
            .get();
      } else {
        snapshots = await collection
            .where(keyWaterGiven, isEqualTo: false)
            .orderBy(keyWater, descending: true)
            .get();
      }
    }

    int srNo = 0;
    for (var doc in snapshots.docs) {
      srNo = srNo + 1;
      try {
        await doc.reference.get().then(
          (value) {
            var y = value.data();
            pendingEntry pe = pendingEntry(
                srnum: srNo.toString(),
                name: y![keyName],
                mobile: y![keyMobile],
                uid: y![keyUid],
                amount: (widget.pendingType == housePendingType)
                    ? y![keyHouse].toString()
                    : y![keyWater].toString());
            entries.add(pe);
          },
        );
      } catch (e) {
        popAlert(
            context, kTitleTryCatchFail, e.toString(), getWrongIcon(50.0), 1);
      }
    }
    srNo = 0;

    final invoice = pendingInvoice(
        info: InvoiceInfo(
            formula:
                '$txtForumlaIn$equals$inFormula; $txtForumlaOut$equals$outFormula; $txtForumlaRemain$equals$remainFormula',
            year: dropdownValueYear,
            sortingType: dropdownValuePendingSort,
            taxType:
                (widget.pendingType == housePendingType) ? keyHouse : keyWater),
        pendingInvoiceItems: entries);

    final pdfFile = await invoice.generate(actPending, registeredName, "", "");

    await PdfApi.openFile(pdfFile);
    //END - fetch data to display in pdf
  }

  //.where(keyWaterGiven, isEqualTo: true)
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[350],
      //alignment: Alignment.topLeft,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(
                splashColor: clrIconSpalsh,
                splashRadius: iconSplashRadius,
                alignment: Alignment.topRight,
                onPressed: () async {
                  //TODO: update pendingInvoiceItems from DB later.

                  await createPDFPendingEntries();
                },
                icon: Icon(Icons.download, size: 30.0),
                color: getColor(widget.pendingType),
                tooltip: txtDownloadPending,
              ),
              SizedBox(
                width: 10.0,
              ),
              DropdownButton(
                style: TextStyle(
                  backgroundColor: getColor(widget.pendingType),
                ),
                borderRadius: BorderRadius.circular(12.0),
                dropdownColor: clrAmber,

                alignment: Alignment.topRight,

                // Initial Value
                value: dropdownValuePendingSort,
                // Down Arrow Icon
                icon: Icon(Icons.sort, color: clrAmber),
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
                      dropdownValuePendingSort = newValue!;
                    },
                  );
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              DropdownButton(
                borderRadius: BorderRadius.circular(12.0),
                dropdownColor: clrAmber,

                alignment: Alignment.topRight,

                // Initial Value
                value: dropdownValueYear,
                // Down Arrow Icon
                icon: Icon(Icons.date_range, color: clrAmber),
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
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
          Expanded(
            child: pendingList(
                yearDropDownValue: dropdownValueYear,
                pendingType: widget.pendingType,
                orderType: dropdownValuePendingSort),
          ),
        ],
      ),
    );
  }
}

class pendingMoney extends StatefulWidget {
  static String id = "pendingscreen";
  pendingMoney({Key? key}) : super(key: key);

  @override
  _pendingMoneyState createState() => _pendingMoneyState();
}

class _pendingMoneyState extends State<pendingMoney> {
  String pageName = actPending;

  // Initial Selected Value

  List<Icon> lsIcons = [
    Icon(Icons.home, color: Colors.black),
    Icon(Icons.water, color: Colors.black),
  ];
  List<Widget> lsWidget = <Widget>[];
  List<String> lsText = [txtTaxTypeHouse, txtTaxTypeWater];

  @override
  Widget build(BuildContext context) {
    gContext = context;
    onPressedDrawerPending = false;
    lsWidget.add(
      Expanded(
        child: pendingContainer(pendingType: keyHouseGiven),
      ),
    );
    lsWidget.add(
      Expanded(
        child: pendingContainer(pendingType: keyWaterGiven),
      ),
    );

    //Widget formulaWidget = formulaLive();
    Widget infoIcon = Icon(Icons.info);
    return tabScffold(
      context,
      lsIcons.length,
      lsText,
      lsIcons,
      lsWidget,
      pageName,
      clrAmber,
      infoIcon,
    );
  }
}
