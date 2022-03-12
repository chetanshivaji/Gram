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

//SingleChildScrollView objSearchList = SingleChildScrollView();
List<DataRow> gLdr = [];

String name = ""; //TODO: check if need to remove this
//MaterialStateProperty<Color> clrButton =
//MaterialStateProperty.all<Color>(Colors.red);

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

    for (var yr in items) {
      List<DataCell> ldataCell = [];
      //search DB
      try {
        await FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + yr)
            .doc(mobile)
            .get()
            .then(
          (value) {
            var y = value.data();

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
                    y[keyHouseGiven] ? getRightIcon(20.0) : getWrongIcon(20.0),
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
                    y[keyWaterGiven] ? getRightIcon(20.0) : getWrongIcon(20.0),
                  ],
                ),
              ),
            );
          },
        );

        ldataRow.add(DataRow(cells: ldataCell));
      } catch (e) {
        popAlert(
            context, kTitleTryCatchFail, e.toString(), getWrongIcon(50.0), 1);
      }
    }

    return ldataRow;
  }

  @override
  Widget build(BuildContext context) {
    bool pressed = true;

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
                    /*
                    style: ButtonStyle(
                      backgroundColor: clrButton,
                    ),
                    */
                    child: Text(
                      bLabelSubmit,
                    ),
                    onPressed: pressed
                        ? () async {
                            if (_formKey2.currentState!.validate()) {
                              var ldr = await _buildListPending();
                              //search DB
                              for (var yr in items) {
                                try {
                                  _name = await FirebaseFirestore.instance
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
                                  popAlert(context, kTitleTryCatchFail,
                                      e.toString(), getWrongIcon(50.0), 1);
                                }
                              }
                              setState(
                                () {
                                  name = _name;
                                  gLdr = ldr;
                                  //clrButton = MaterialStateProperty.all<Color>(
                                  //  Colors.yellow);
                                },
                              );
                            }
                            pressed = false;
                          }
                        : null,
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
    );
  }
}
