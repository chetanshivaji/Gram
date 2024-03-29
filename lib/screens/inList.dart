import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class inList extends StatelessWidget {
  String inType = "";
  String orderType = "";
  String yearDropDownValue = "";
  String sDate = "";
  String eDate = "";

  inList(
      {Key? key,
      this.sDate = "",
      this.eDate = "",
      this.yearDropDownValue = "2021",
      this.inType = collPrefixInHouse,
      this.orderType = keyDate})
      : super(key: key);

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> docSnapshot) {
    List<DataRow> ldataRow = [];
    int srNo = 0;
    for (var l in docSnapshot) {
      List<DataCell> ldataCell = [];

      //check if fetched date is between start and end date.
      DateTime fd = DateTime.parse(l.get(keyDate).split(' ')[0]);
      DateTime sd = DateTime.parse(DateTime.parse(sDate)
          .subtract(const Duration(days: 1))
          .toString()
          .split(' ')[0]);

      DateTime ed = DateTime.parse(DateTime.parse(eDate)
          .add(const Duration(days: 1))
          .toString()
          .split(' ')[0]);

      if (inType == collPrefixInExtra) {
        if (fd.isBefore(ed) && fd.isAfter(sd)) {
          try {
            srNo = srNo + 1;
            ldataCell.add(DataCell(Text(
              srNo.toString(),
              style: getTableFirstColStyle(),
            )));
            ldataCell.add(DataCell(Text(l.get(keyAmount).toString())));
            ldataCell.add(DataCell(Text(l.get(keyReason))));
            ldataCell.add(DataCell(Text(l.get(keyDate))));
            ldataCell.add(DataCell(Text(l.get(keyRegisteredName))));

            ldataRow.add(DataRow(cells: ldataCell));
          } catch (e) {
            //do nothing . TODO: stream builder fetching old session data
            print(e);
          }
        }
      } else {
        if (fd.isBefore(ed) && fd.isAfter(sd)) {
          try {
            srNo = srNo + 1;
            ldataCell.add(DataCell(Text(
              srNo.toString(),
              style: getTableFirstColStyle(),
            )));
            ldataCell.add(DataCell(Text(l.get(keyName))));
            ldataCell.add(DataCell(Text(l.get(keyMobile))));
            ldataCell.add(DataCell(Text(l.get(keyUid))));
            ldataCell.add(DataCell(Text(l.get(keyAmount).toString())));
            if (this.inType == collPrefixInHouse) {
              //For House, discount and fine columns
              ldataCell.add(DataCell(Text(l.get(keyDiscount).toString())));
              ldataCell.add(DataCell(Text(l.get(keyFine).toString())));
            }
            ldataCell.add(DataCell(Text(l.get(keyDate))));
            ldataCell.add(DataCell(Text(l.get(keyRegisteredName))));

            ldataRow.add(DataRow(cells: ldataCell));
          } catch (e) {
            //do nothing TODO: stream builder fetching old session data
            print(e);
          }
        }
      }
    }
    return ldataRow;
  }

  SingleChildScrollView getInExtraTable(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: getTableHeadingTextStyle(),
          border: getTableBorder(),
          dataTextStyle: TextStyle(
            color: Colors.indigoAccent,
          ),
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeading_srNum,
                style: getStyle(actIn),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingAmount,
                style: getStyle(actIn),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingReason,
                style: getStyle(actIn),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingDate,
                style: getStyle(actIn),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(gContext)!.tableHeadingUser,
                style: getStyle(actIn),
              ),
            ),
          ],
          rows: _buildList(context, snapshot.data!.docs),
        ),
      ),
    );
  }

  SingleChildScrollView getInHouseWaterTable(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: getTableHeadingTextStyle(),
          border: getTableBorder(),
          dataTextStyle: TextStyle(
            color: Colors.indigoAccent,
          ),
          columns: (this.inType == collPrefixInHouse)
              ? <DataColumn>[
                  //For House, discount and fine columns
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeading_srNum,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeadingName,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeadingMobile,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeadingUid,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeadingAmount,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.labelDiscount,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.labelFine,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeadingDate,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeadingUser,
                      style: getStyle(actIn),
                    ),
                  ),
                ]
              : <DataColumn>[
                  //For Water, NO discount and fine columns
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeading_srNum,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeadingName,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeadingMobile,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeadingUid,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeadingAmount,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeadingDate,
                      style: getStyle(actIn),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppLocalizations.of(gContext)!.tableHeadingUser,
                      style: getStyle(actIn),
                    ),
                  ),
                ],
          rows: _buildList(context, snapshot.data!.docs),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    gContext = context;
    Stream<QuerySnapshot<Object?>> stm;
    if (orderType == AppLocalizations.of(gContext)!.txtLtoH) {
      stm = FirebaseFirestore.instance
          .collection(village + pin)
          .doc(docMainDb)
          .collection(inType + yearDropDownValue)
          .orderBy(keyAmount, descending: false)
          .snapshots();
    } else if (orderType == AppLocalizations.of(gContext)!.txtHtoL) {
      stm = FirebaseFirestore.instance
          .collection(village + pin)
          .doc(docMainDb)
          .collection(inType + yearDropDownValue)
          .orderBy(keyAmount, descending: true)
          .snapshots();
    } else {
      stm = FirebaseFirestore.instance
          .collection(village + pin)
          .doc(docMainDb)
          .collection(inType + yearDropDownValue)
          .orderBy(keyDate, descending: true)
          .snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: stm,
      //Async snapshot.data-> query snapshot.docs -> docuemnt snapshot,.data["key"]
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(AppLocalizations.of(gContext)!.msgNoExpense);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(AppLocalizations.of(gContext)!.msgLoading);
        }

        return (inType == collPrefixInExtra)
            ? getInExtraTable(context, snapshot)
            : getInHouseWaterTable(context, snapshot);
      },
    );
  }
}
