import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'pendingList.dart';
import 'package:money/model/invoice.dart';
import 'package:money/api/pdf_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String dropdownValuePendingSort = AppLocalizations.of(gContext)!.txtHtoL;

class pendingContainer extends StatefulWidget {
  String pendingType = "";
  pendingContainer({Key? key, this.pendingType = keyHouseGiven})
      : super(key: key) {
    dropdownValuePendingSort = AppLocalizations.of(gContext)!.txtHtoL;
  }

  @override
  _pendingContainerState createState() => _pendingContainerState();
}

class _pendingContainerState extends State<pendingContainer> {
  Future<void> createPDFPendingEntries(String dropdownValuePendingSort) async {
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
        popAlert(context, AppLocalizations.of(gContext)!.kTitleTryCatchFail,
            e.toString(), getWrongIcon(50.0), 1);
      }
    }
    srNo = 0;

    String formIn = AppLocalizations.of(gContext)!.txtForumlaIn;
    String formOut = AppLocalizations.of(gContext)!.txtForumlaOut;
    String formRemain = AppLocalizations.of(gContext)!.txtForumlaRemain;
    final invoice = pendingInvoice(
        info: InvoiceInfo(
            formula:
                '$formIn$equals$inFormula; $formOut$equals$outFormula; $formRemain$equals$remainFormula',
            year: dropdownValueYear,
            sortingType: dropdownValuePendingSort,
            taxType: (widget.pendingType == housePendingType)
                ? AppLocalizations.of(gContext)!.txtTaxTypeHouse
                : AppLocalizations.of(gContext)!.txtTaxTypeWater),
        pendingInvoiceItems: entries);

    /*
    //Pdf only in english because of Marathi font disturbed.
    final pdfFile = await invoice.generate(
        AppLocalizations.of(gContext)!.pageNamePending, registeredName, "", "");
      */

    final pdfFile =
        await invoice.generate(pageNamePending, registeredName, "", "");

    await PdfApi.openFile(pdfFile);
    //END - fetch data to display in pdf
  }

  //.where(keyWaterGiven, isEqualTo: true)
  @override
  Widget build(BuildContext context) {
    gContext = context;

    var itemsSort = [
      AppLocalizations.of(gContext)!.txtHtoL,
      AppLocalizations.of(gContext)!.txtLtoH,
    ];
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

                  await createPDFPendingEntries(dropdownValuePendingSort);
                },
                icon: Icon(Icons.download, size: 30.0),
                color: getColor(widget.pendingType),
                tooltip: AppLocalizations.of(gContext)!.txtDownloadPending,
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
  // Initial Selected Value

  List<Icon> lsIcons = [
    Icon(Icons.home, color: Colors.black),
    Icon(Icons.water, color: Colors.black),
  ];
  List<Widget> lsWidget = <Widget>[];

  @override
  Widget build(BuildContext context) {
    gContext = context;
    String actType = actPending;
    String pageName = AppLocalizations.of(gContext)!.pageNamePending;
    List<String> lsText = [
      AppLocalizations.of(gContext)!.txtTaxTypeHouse,
      AppLocalizations.of(gContext)!.txtTaxTypeWater
    ];

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
      actType,
      pageName,
      clrAmber,
      infoIcon,
    );
  }
}
