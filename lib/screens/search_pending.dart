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

SingleChildScrollView objSearchList = SingleChildScrollView();
String _name = "";
String name = "";

class _searchScreenState extends State<searchScreen> {
  String mobile = "";
  int house = 0;
  int water = 0;
  bool houseGiven = false;
  bool waterGiven = false;
  String name = "";

  String _mobile = "";
  int _house = 0;
  int _water = 0;
  bool _houseGiven = false;
  bool _waterGiven = false;
  String _name = "";

  final _formKey2 = GlobalKey<FormState>();

  Future<List<DataRow>> _buildListPending() async {
    List<DataRow> ldataRow = [];

    for (var yr in items) {
      List<DataCell> ldataCell = [];
      //search DB
      try {
        var collection =
            FirebaseFirestore.instance.collection(dbYearPrefix + yr);
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
                  y!["house"].toString(),
                ),
              ),
            );
            ldataCell.add(
              DataCell(
                y["houseGiven"] ? getRightIcon() : getWrongIcon(),
              ),
            );
            ldataCell.add(
              DataCell(
                Text(
                  y["water"].toString(),
                ),
              ),
            );
            ldataCell.add(
              DataCell(
                y["waterGiven"] ? getRightIcon() : getWrongIcon(),
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
        title: Text("Search"),
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
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.mobile_friendly),
                          hintText: "Enter mobile number to search details",
                          labelText: "Mobile *"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (value == null || value.isEmpty) {
                          return 'Please enter number';
                        }
                        if (value.length != 10) {
                          return "Please enter 10 digits!";
                        }
                        mobile = value;
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    child: const Text(
                      'Submit',
                    ),
                    onPressed: () async {
                      if (_formKey2.currentState!.validate()) {
                        var ldr = await _buildListPending();
                        //search DB
                        try {
                          await FirebaseFirestore.instance
                              .collection(dbYearPrefix + dropdownValueYear)
                              .doc(mobile)
                              .get()
                              .then(
                            (value) {
                              var y = value.data();
                              _name = y!["name"];
                            },
                          );
                        } catch (e) {
                          print(e);
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
                                        'Year',
                                        style: getStyle("PENDING"),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'House',
                                        style: getStyle("PENDING"),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Status',
                                        style: getStyle("PENDING"),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Water',
                                        style: getStyle("PENDING"),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Status',
                                        style: getStyle("PENDING"),
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
                "Name  = $name",
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


/*
class searchScreen extends StatefulWidget {
  static String id = "searchscreen";
  const searchScreen({Key? key}) : super(key: key);
  @override
  _searchScreenState createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  String mobile = "";
  int house = 0;
  int water = 0;
  bool houseGiven = false;
  bool waterGiven = false;
  String name = "";

  String _mobile = "";
  int _house = 0;
  int _water = 0;
  bool _houseGiven = false;
  bool _waterGiven = false;
  String _name = "";
  String name = "";

  final _formKey2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            yearTile(clr: Colors.blue),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Form(
                    key: _formKey2,
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.mobile_friendly),
                          hintText: "Enter mobile number to search details",
                          labelText: "Mobile *"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (value == null || value.isEmpty) {
                          return 'Please enter number';
                        }
                        if (value.length != 10) {
                          return "Please enter 10 digits!";
                        }
                        mobile = value;
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    child: const Text(
                      'Submit',
                    ),
                    onPressed: () async {
                      if (_formKey2.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Processing Data'),
                          ),
                        );

                        //search DB
                        try {
                          await FirebaseFirestore.instance
                              .collection(dbYearPrefix + dropdownValueYear)
                              .doc(mobile)
                              .get()
                              .then(
                            (value) {
                              var y = value.data();

                              _house = y!["house"];
                              _houseGiven = y["houseGiven"];
                              _water = y["water"];
                              _waterGiven = y["waterGiven"];
                              _name = y["name"];
                            },
                          );
                        } catch (e) {
                          print(e);
                        }

                        setState(
                          () {
                            name = _name;
                            house = _house;
                            houseGiven = _houseGiven;
                            water = _water;
                            waterGiven = _waterGiven;
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
              title: Text("Name  = $name"),
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text("House Amount  = $house"),
              trailing: (houseGiven == true) ? getRightIcon() : getWrongIcon(),
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text("Water Amount  = $water"),
              trailing: (waterGiven == true) ? getRightIcon() : getWrongIcon(),
            ),
          ],
        ),
      ),
    );
  }
}


*/