import 'package:flutter/material.dart';
import 'package:money/constants.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'formula.dart';

// Create a Form widget.
class HouseWaterForm extends StatefulWidget {
  String formType = "";
  HouseWaterForm({Key? key, this.formType = "HOUSE"}) : super(key: key);

  @override
  HouseWaterFormState createState() {
    return HouseWaterFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class HouseWaterFormState extends State<HouseWaterForm> {
  final _formKey = GlobalKey<FormState>();

  String name = "";
  int amount = 0;
  String mobile = "";

  void updateFormulaValues(String newEntryAmount, String typeInOut) async {
    int total = await FirebaseFirestore.instance
        .collection(colletionName_forumla)
        .doc(documentName_formula)
        .get()
        .then((value) {
      var y = value.data();
      return (typeInOut == "in") ? y!["totalIn"] : y!["totalOut"];
    });

    //update formula
    if (typeInOut == "in") {
      FirebaseFirestore.instance
          .collection("formula")
          .doc("calculation")
          .update({'totalIn': (total + int.parse(newEntryAmount))});
    } else {
      FirebaseFirestore.instance
          .collection("formula")
          .doc("calculation")
          .update({'totalOut': (total + int.parse(newEntryAmount))});
    }
  }

  int waterAmount = 0;
  int houseAmount = 0;
  String waterName = "";
  String houseName = "";

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          yearTile(clr: clrGreen),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Expanded(
            child: TextFormField(
              onChanged: (text) async {
                if (text.length == 10) {
                  if (widget.formType == "HOUSE") {
                    try {
                      houseAmount = await FirebaseFirestore.instance
                          .collection(dbYearPrefix + dropdownValueYear)
                          .doc(text)
                          .get()
                          .then(
                        (value) {
                          var y = value.data();
                          return y!["house"];
                        },
                      );
                    } catch (e) {
                      print(e);
                    }

                    try {
                      houseName = await FirebaseFirestore.instance
                          .collection(dbYearPrefix + dropdownValueYear)
                          .doc(text)
                          .get()
                          .then(
                        (value) {
                          var y = value.data();
                          if (y!["houseGiven"] == true) {
                            return paidMsg;
                          } else
                            return y["name"];
                        },
                      );
                    } catch (e) {
                      print(e);
                    }

                    setState(
                      () {
                        name = houseName;
                        amount = houseAmount;
                      },
                    );
                  } else {
                    try {
                      waterAmount = await FirebaseFirestore.instance
                          .collection(dbYearPrefix + dropdownValueYear)
                          .doc(text)
                          .get()
                          .then(
                        (value) {
                          var y = value.data();
                          return y!["water"];
                        },
                      );
                    } catch (e) {
                      print(e);
                    }

                    try {
                      waterName = await FirebaseFirestore.instance
                          .collection(dbYearPrefix + dropdownValueYear)
                          .doc(text)
                          .get()
                          .then(
                        (value) {
                          var y = value.data();
                          if (y!["waterGiven"] == true) {
                            return paidMsg;
                          } else
                            return y["name"];
                        },
                      );
                    } catch (e) {
                      print(e);
                    }

                    setState(
                      () {
                        name = waterName;
                        amount = waterAmount;
                      },
                    );
                  }
                }
              },

              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.mobile_friendly),
                  hintText: "Enter mobile number",
                  labelText: "Mobile *"),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter number';
                }
                if (value.length != 10) {
                  return "Please enter 10 digits!";
                }
                if (name == "") {
                  return "Please enter correct number/Number not found in database";
                }
                if (name == paidMsg) {
                  return "Already paid for this User";
                }
                mobile = value;
                //check if it is only number
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Expanded(
            child: ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "Name = $name",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Expanded(
            child: ListTile(
              leading: Icon(Icons.attach_money),
              title: Text(
                "Amount = $amount",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (widget.formType == "HOUSE") {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );
                      FirebaseFirestore.instance
                          .collection("inHouse" + dropdownValueYear)
                          .add(
                        {
                          'name': name,
                          'mobile': mobile,
                          'amount': amount,
                          'date': DateTime.now().toString(),
                          'user': userMail,
                        },
                      );
                      FirebaseFirestore.instance
                          .collection(dbYearPrefix + dropdownValueYear)
                          .doc(mobile)
                          .update({'houseGiven': true});

                      updateFormulaValues(amount.toString(),
                          "in"); //fetch exisiting value from formula and update new value.

                      showAlertDialog(
                        context,
                        titleSuccess,
                        subtitleSuccess,
                        getRightIcon(),
                      );
                      String message =
                          "Dear $name $mobile, Thanks for paying House amount $amount, Received!";
                      List<String> recipents = [mobile];
                      sendTextToPhone(message, recipents);
                    }
                    // Validate returns true if the form is valid, or false otherwise.
                  } else {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );
                      FirebaseFirestore.instance
                          .collection("inWater" + dropdownValueYear)
                          .add(
                        {
                          'name': name,
                          'mobile': mobile,
                          'amount': amount,
                          'date': DateTime.now().toString(),
                          'user': userMail,
                        },
                      );
                      FirebaseFirestore.instance
                          .collection(dbYearPrefix + dropdownValueYear)
                          .doc(mobile)
                          .update({'waterGiven': true});

                      updateFormulaValues(amount.toString(),
                          "in"); //fetch exisiting value from formula and update new value.
                      showAlertDialog(
                        context,
                        titleSuccess,
                        subtitleSuccess,
                        getRightIcon(),
                      );

                      String message =
                          "Dear $name $mobile, Thanks for paying Water amount $amount, Received!";
                      List<String> recipents = [mobile];
                      sendTextToPhone(message, recipents);
                    }
                  }
                },
                child: const Text(
                  'Submit',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Create a Form widget.
class ExtraIncomeForm extends StatefulWidget {
  const ExtraIncomeForm({Key? key}) : super(key: key);

  @override
  ExtraIncomeFormState createState() {
    return ExtraIncomeFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ExtraIncomeFormState extends State<ExtraIncomeForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<HouseWaterFormState>.
  final _formKey = GlobalKey<FormState>();
  String reason = "";
  int amount = 0;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          yearTile(clr: clrGreen),
          Padding(padding: EdgeInsets.only(top: 20)),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.text_snippet),
                  hintText: "Income Reason",
                  labelText: "Reason *"),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                reason = value;
                return null;
              },
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.attach_money),
                  hintText: "Enter amount",
                  labelText: "Amount *"),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                amount = int.parse(value);
                /*
                //check if it is only number  
                if (value.digit) {
                  return 'Please enter some text';
                }
                */
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Processing Data'),
                      ),
                    );
                    FirebaseFirestore.instance
                        .collection("inExtra" + dropdownValueYear)
                        .add(
                      {
                        'reason': reason,
                        'amount': amount,
                        'date': DateTime.now().toString(),
                        'user': userMail,
                      },
                    );
                    updateFormulaValues(amount.toString(),
                        "in"); //fetch exisiting value from formula and update new value.
                    showAlertDialog(
                        context, titleSuccess, subtitleSuccess, getRightIcon());
                  }
                },
                child: const Text(
                  'Submit',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class inMoney extends StatelessWidget {
  static String id = "inscreen";
  inMoney({Key? key}) : super(key: key);

  String pageName = "IN";
  List<Icon> lsIcons = [
    Icon(Icons.home, color: Colors.black),
    Icon(Icons.water, color: Colors.black),
    Icon(Icons.foundation_outlined, color: Colors.black),
  ];
  List<Widget> lsWidget = <Widget>[];
  List<String> lsText = ["Home", "Water", "Extra Income"];

  @override
  Widget build(BuildContext context) {
    lsWidget.add(
      HouseWaterForm(formType: "HOUSE"),
    );
    lsWidget.add(
      HouseWaterForm(formType: "WATER"),
    );
    lsWidget.add(
      ExtraIncomeForm(),
    );
    Widget infoIcon = Icon(Icons.info);
    return tabScffold(lsIcons.length, lsText, lsIcons, lsWidget, pageName,
        clrGreen, infoIcon);
  }
}
