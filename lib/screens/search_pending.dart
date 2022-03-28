import 'dart:async';

import 'package:flutter/material.dart';
import 'package:money/util.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/constants.dart';

class searchScreen extends StatefulWidget {
  static String id = "searchscreen";
  const searchScreen({Key? key}) : super(key: key);
  @override
  _searchScreenState createState() => _searchScreenState();
}

List<DataRow> gLdr = [];
var mobileUids;
bool uidTextField = false;
String uidList = "";
String uidHintText = msgEnterUid;
var _textController_Uid = TextEditingController();
String nameEntry = "";

String name = ""; //TODO: check if need to remove this

class _searchScreenState extends State<searchScreen> {
  String mobile = "";
  String uid = "";
  int house = 0;
  int water = 0;
  bool houseGiven = false;
  bool waterGiven = false;
  String name = "";

  String _name = "";

  final _formKey2 = GlobalKey<FormState>();

  void setStateEmptyEntries() {
    setState(
      () {
        name = '';
      },
    );
    return;
  }

  Future<List<DataRow>> _buildListPending(String id) async {
    List<DataRow> ldataRow = [];

    bool mobileUserFound = false;
    for (var yr in items) {
      List<DataCell> ldataCell = [];
      //search DB
      try {
        await FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yr)
            .doc(mobile + id)
            .get()
            .then(
          (value) {
            if (value.exists) {
              mobileUserFound = true;
              var y = value.data();
              //if (_name == "") {
              _name = y![keyName];
              //}

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
                        y![keyHouse].toString(),
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
        popAlert(
            context, kTitleTryCatchFail, e.toString(), getWrongIcon(50.0), 1);
      }
    }
    if (mobileUserFound == false) {
      popAlert(context, kTitleTryCatchFail, kSubTitleUserNotFound,
          getWrongIcon(50.0), 1);
    }

    return ldataRow;
  }

  Future<void> buildAndSetList() async {
    var ldr = await _buildListPending(_textController_Uid.text);
    if (ldr.isEmpty) {
      setStateEmptyEntries();
      gLdr = ldr;
      return;
    }

    setState(
      () {
        name = _name;
        gLdr = ldr;
      },
    );
  }

  Future<void> setNameEmail(String uid) async {
    //fecth and display user info on screen

    await FirebaseFirestore.instance
        .collection(village + pin)
        .doc(docMainDb)
        .collection(docMainDb + dropdownValueYear)
        .doc(mobile.toString() + uid)
        .get()
        .then(
      (value) {
        if (value.exists) {
          var y = value.data();
          nameEntry = y![keyName];
          //emailEntry = y[keyEmail];
        }
        setState(
          () {
            name = nameEntry;
            //email = emailEntry;
          },
        );
      },
    );
  }

  Future<void> checkMobileUid(mobValue) async {
    String uids = "";
    mobile =
        mobValue; //set here, otherewise this will be set in validator after click on submit.
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
                kTitleMobileNotPresent,
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
                  uidTextField =
                      false; //disale to edit , make enable false or read only true. check it.
                  _textController_Uid.text = mobileUids[0];
                },
              );
              //await setNameEmail(mobileUids[0]);
              await buildAndSetList();
            } else if (mobileUids.length > 1) {
              //display all uids and choose one.
              for (var id in mobileUids) {
                uids = uids + ", " + id;
              }
              //pop up message with all uids and setup hint text with uids.
              popAlert(
                context,
                kTitleMultiUids,
                uids,
                getWrongIcon(50),
                1,
              );

              setState(
                () {
                  uidTextField =
                      true; //disale to edit , make enable false or read only true. check it.
                  uidList = uids;
                  uidHintText = uidList;
                },
              );
            } else {
              //mobile not found pop alert
              popAlert(
                context,
                kTitleMobileNotPresent,
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
        kTitleMobileNotPresent,
        "",
        getWrongIcon(50),
        1,
      );
      // _textController_newMobile.clear();
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    bool pressed = true;

    return WillPopScope(
      onWillPop: () {
        //trigger leaving and use own data
        Navigator.pop(context, false);
        gLdr = [];
        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(bLabelSearch),
        ),
        body: Container(
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
                          hintText: msgEnterMobileNumber,
                          labelText: labelMobile),
                      // The validator receives the text that the user has entered.
                      onChanged: (value) async {
                        if (value.length == 10) {
                          checkMobileUid(value);
                        }
                        if (value.length < 10) {
                          _textController_Uid.clear();
                          setState(
                            () {
                              name = "";
                              //email = "";
                              gLdr = [];
                            },
                          );
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return msgEnterMobileNumber;
                        }
                        if (value == null || value.isEmpty) {
                          return msgOnlyNumber;
                        }
                        if (value.length != 10) {
                          return msgTenDigitNumber;
                        }
                        if (!isNumeric(value)) {
                          return msgOnlyNumber;
                        }
                        mobile = value;
                        return null;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    TextFormField(
                      controller: _textController_Uid,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.wb_incandescent_outlined),
                          hintText: uidHintText,
                          labelText: labelUid),
                      onFieldSubmitted: (val) {
                        uid = val;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return msgEnterUid;
                        }

                        uid = value;
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    //after add button press fill up info by fetching mob+uid from last year.
                    await buildAndSetList();
                  },
                  child: Text(
                    bLabelAdd,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "$txtName$equals$name",
                  style: getTableHeadingTextStyle(),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: getTableHeadingTextStyle(),
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          width: 1.5,
                          color: Colors.black,
                        ),
                      ),
                      dataTextStyle: TextStyle(
                        color: Colors.indigoAccent,
                      ),
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            tableHeadingYear,
                            style: getStyle(actPending),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            tableHeadingHouse,
                            style: getStyle(actPending),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            tableHeadingWater,
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
    );
  }
}
