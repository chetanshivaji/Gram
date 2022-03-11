import 'dart:async';

import 'package:flutter/material.dart';
import 'package:money/util.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/constants.dart';
import 'package:money/constants.dart';

class searchScreen extends StatefulWidget {
  static String id = "searchscreen";
  const searchScreen({Key? key}) : super(key: key);
  @override
  _searchScreenState createState() => _searchScreenState();
}

SingleChildScrollView objSearchList = SingleChildScrollView();

String name = ""; //TODO: check if need to remove this

class _searchScreenState extends State<searchScreen> {
  String mobile = "";
  int house = 0;
  int water = 0;
  bool houseGiven = false;
  bool waterGiven = false;
  String name = "";

  String _name = "";

  final _formKey2 = GlobalKey<FormState>();

  Future<List<DataRow>> _buildListPending() async {
    List<DataRow> ldataRow = [];
    //var ls = await getLoggedInUserVillagePin();
    for (var yr in items) {
      List<DataCell> ldataCell = [];
      //search DB
      try {
        var collection = FirebaseFirestore.instance
            //.collection(ls[0] + ls[1])
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yr);
        var doc = await collection.doc(mobile).get();

        await doc.reference.get().then(
          (value) {
            var y = value.data();

            ldataCell.add(DataCell(Text(
              yr + " -> ",
              style: getTableHeadingTextStyle(),
            )));
            ldataCell.add(
              DataCell(
                Text(
                  y![keyHouse].toString(),
                ),
              ),
            );
            ldataCell.add(
              DataCell(
                y[keyHouseGiven] ? getRightIcon() : getWrongIcon(),
              ),
            );
            ldataCell.add(
              DataCell(
                Text(
                  y[keyWater].toString(),
                ),
              ),
            );
            ldataCell.add(
              DataCell(
                y[keyWaterGiven] ? getRightIcon() : getWrongIcon(),
              ),
            );
          },
        );

        ldataRow.add(DataRow(cells: ldataCell));
      } catch (e) {
        print(e);
      }
    }
    return ldataRow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bLabelSearch),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Form(
                    key: _formKey2,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.mobile_friendly),
                          hintText: msgEnterMobileNumber,
                          labelText: labelMobile),
                      // The validator receives the text that the user has entered.
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
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    child: Text(
                      bLabelSubmit,
                    ),
                    onPressed: () async {
                      //var ls = await getLoggedInUserVillagePin();
                      if (_formKey2.currentState!.validate()) {
                        var ldr = await _buildListPending();
                        //search DB
                        for (var yr in items) {
                          try {
                            _name = await FirebaseFirestore.instance
                                //.collection(ls[0] + ls[1])
                                .collection(village + pin)
                                .doc(docMainDb)
                                .collection(docMainDb + yr)
                                .doc(mobile)
                                .get()
                                .then(
                              (value) {
                                var y = value.data();
                                if (y != null) {
                                  //_name = y[keyName];
                                  return y[keyName];
                                }
                                return "";
                              },
                            );
                            if (_name != "") break;
                          } catch (e) {
                            print(e);
                          }
                        }
                        setState(
                          () {
                            name = _name;
                            objSearchList = SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingTextStyle: getTableHeadingTextStyle(),
                                  columnSpacing: 5.0,
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
                                        tableHeadingStatus,
                                        style: getStyle(actPending),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        tableHeadingWater,
                                        style: getStyle(actPending),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        tableHeadingStatus,
                                        style: getStyle(actPending),
                                      ),
                                    ),
                                  ],
                                  rows: ldr,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                "$txtName$equals$name",
                style: getTableHeadingTextStyle(),
              ),
            ),
            Expanded(child: objSearchList),
          ],
        ),
      ),
    );
  }
}
