import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money/constants.dart';
import 'package:money/util.dart';

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
                              .collection(dbYear + dropdownValueYear)
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
