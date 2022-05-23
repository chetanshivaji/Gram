import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class searchScreen extends StatefulWidget {
  static String id = "searchscreen";
  const searchScreen({Key? key}) : super(key: key);
  @override
  _searchScreenState createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  List<TextSpan> multiUidsTextSpan = [];
  List<TextSpan> multiUids = [];

  List<DataRow> gLdr = [];
  var mobileUids;
  String uid = "";
  String mobile = "";
  int house = 0;
  int water = 0;
  bool houseGiven = false;
  bool waterGiven = false;
  String name = "";
  String _name = "";
  String extraInfo = "";
  String _extraInfo = "";

  final _formKey2 = GlobalKey<FormState>();

  void setStateEmptyEntries() {
    setState(
      () {
        name = '';
        extraInfo = "";
      },
    );
    return;
  }

  Future<List<DataRow>> _buildListPending() async {
    List<DataRow> ldataRow = [];
    int srNo = 0;
    bool mobileUserFound = false;

    for (var yr in items) {
      List<DataCell> ldataCell = [];
      //search DB
      try {
        await FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yr)
            .doc(mobile + uid)
            .get()
            .then(
          (value) {
            if (value.exists) {
              mobileUserFound = true;

              var y = value.data();

              _name = y![keyName];
              _extraInfo = y[keyExtraInfo];

              srNo = srNo + 1;
              ldataCell.add(DataCell(Text(
                srNo.toString(),
                style: getTableFirstColStyle(),
              )));

              ldataCell.add(
                DataCell(
                  Text(
                    yr + " -> ",
                    style: getTableHeadingTextStyle(),
                  ),
                ),
              );
              ldataCell.add(
                DataCell(
                  Row(
                    children: <Widget>[
                      Text(
                        y[keyHouse].toString(),
                      ),
                      y[keyHouseGiven]
                          ? getRightIcon(20.0)
                          : getWrongIcon(20.0),
                    ],
                  ),
                ),
              );
              ldataCell.add(
                DataCell(
                  Row(
                    children: <Widget>[
                      Text(
                        y[keyWater].toString(),
                      ),
                      y[keyWaterGiven]
                          ? getRightIcon(20.0)
                          : getWrongIcon(20.0),
                    ],
                  ),
                ),
              );
              ldataRow.add(DataRow(cells: ldataCell));
            }
            //else if value not exist do nothing, //means user not found for that year.
          },
        );
      } catch (e) {
        popAlert(context, AppLocalizations.of(gContext)!.kTitleTryCatchFail,
            e.toString(), getWrongIcon(50.0), 1);
      }
    }
    if (mobileUserFound == false) {
      popAlert(
          context,
          AppLocalizations.of(gContext)!.kTitleTryCatchFail,
          AppLocalizations.of(gContext)!.kSubTitleUserNotFound,
          getWrongIcon(50.0),
          1);
    }
    return ldataRow;
  }

  Future<void> buildAndSetList() async {
    var ldr = await _buildListPending();
    if (ldr.isEmpty) {
      setStateEmptyEntries();
      gLdr = ldr;
      return;
    }

    setState(
      () {
        name = _name;
        gLdr = ldr;
        extraInfo = _extraInfo;
      },
    );
  }

  Future<void> checkMobileUid(mobValue) async {
    String uids = "";
    //Set here, otherewise this will be set in validator after click on submit.
    mobile = mobValue;
    try {
      await FirebaseFirestore.instance
          .collection(village + pin)
          .doc(docMobileUidMap)
          .get()
          .then(
        (value) async {
          if (value.exists) {
            var y = value.data();
            if (!y!.containsKey(mobValue)) {
              //mobile uid mapping not present.
              popAlert(
                context,
                AppLocalizations.of(gContext)!.kTitleMobileNotPresent,
                "",
                getWrongIcon(50),
                1,
              );
              return;
            }
            mobileUids = y[mobValue];
            //get all uids. if only one directly display
            if (mobileUids.length == 1) {
              uids = mobileUids[0];
              setState(
                () {
                  uid = mobileUids[0];
                },
              );
              await buildAndSetList();
            } else if (mobileUids.length > 1) {
              //display all uids and choose one.
              for (var id in mobileUids) {
                uids = uids + ", " + id;
                multiUidsTextSpan.add(
                  TextSpan(
                    text: id + " , ",
                    style: TextStyle(
                      color: Colors.red[300],
                      backgroundColor: Colors.yellow,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        //make use of Id which has go tapped.
                        uid = id;
                        await buildAndSetList();
                      },
                  ),
                );
              }
              //pop up message with all uids and setup hint text with uids.
              popAlert(
                context,
                AppLocalizations.of(gContext)!.kTitleMultiUids,
                uids,
                getMultiUidIcon(50),
                1,
              );

              setState(
                () {
                  multiUids = multiUidsTextSpan;
                },
              );
            } else {
              //mobile not found pop alert
              popAlert(
                context,
                AppLocalizations.of(gContext)!.kTitleMobileNotPresent,
                "",
                getWrongIcon(50),
                1,
              );
            }
          }
        },
      );
    } catch (e) {
      popAlert(
        context,
        AppLocalizations.of(gContext)!.kTitleMobileNotPresent,
        "",
        getWrongIcon(50),
        1,
      );
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    gContext = context;
    bool pressed = true;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(gContext)!.bLabelSearch),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Form(
                  key: _formKey2,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            icon: Icon(Icons.mobile_friendly),
                            hintText: AppLocalizations.of(gContext)!
                                .msgEnterMobileNumber,
                            labelText:
                                AppLocalizations.of(gContext)!.labelMobile +
                                    txtStar),
                        onChanged: (value) async {
                          if ((value.length < 10) || (value.length > 10)) {
                            multiUidsTextSpan.clear();
                            setState(
                              () {
                                uid = "";
                                name = "";
                                extraInfo = "";
                                gLdr = [];
                                multiUids = [TextSpan()];
                              },
                            );
                          }
                          if (value.length == 10) {
                            await checkMobileUid(value);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(gContext)!
                                .msgEnterMobileNumber;
                          }
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(gContext)!.msgOnlyNumber;
                          }
                          if (value.length != 10) {
                            return AppLocalizations.of(gContext)!
                                .msgTenDigitNumber;
                          }
                          if (!isNumeric(value)) {
                            return AppLocalizations.of(gContext)!.msgOnlyNumber;
                          }
                          mobile = value;
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: multiUids,
                    ),
                  ),
                ),
                getListTile(Icon(Icons.wb_incandescent_outlined),
                    AppLocalizations.of(gContext)!.labelUid, uid),
                getListTile(Icon(Icons.person),
                    AppLocalizations.of(gContext)!.tableHeadingName, name),
                getListTile(Icon(Icons.holiday_village),
                    AppLocalizations.of(gContext)!.labelExtraInfo, extraInfo),
                Expanded(
                  child: SingleChildScrollView(
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
                              style: getStyle(actPending),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              AppLocalizations.of(gContext)!.tableHeadingYear,
                              style: getStyle(actPending),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              AppLocalizations.of(gContext)!.tableHeadingHouse,
                              style: getStyle(actPending),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              AppLocalizations.of(gContext)!.tableHeadingWater,
                              style: getStyle(actPending),
                            ),
                          ),
                        ],
                        rows: gLdr,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
