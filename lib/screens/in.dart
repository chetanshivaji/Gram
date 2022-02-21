import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String mobile = "";
  String tax = "";

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
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.person),
                  hintText: "Enter name",
                  labelText: "Name *"),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                name = value;
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Expanded(
            child: TextFormField(
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
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.attach_money),
                  hintText: "Enter Tax",
                  labelText: "Tax *"),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                tax = value;
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
                onPressed: () {
                  if (widget.formType == "HOUSE") {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );
                      FirebaseFirestore.instance.collection("inHouse").add(
                        {
                          'name': name,
                          'mobile': mobile,
                          'tax': tax,
                          'date': DateTime.now().toString(),
                          'user': userMail,
                        },
                      );
                      updateFormulaValues(tax,
                          "in"); //fetch exisiting value from formula and update new value.

                      showAlertDialog(
                        context,
                        titleSuccess,
                        subtitleSuccess,
                        getRightIcon(),
                      );
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
                      FirebaseFirestore.instance.collection("inWater").add(
                        {
                          'name': name,
                          'mobile': mobile,
                          'tax': tax,
                          'date': DateTime.now().toString(),
                          'user': userMail,
                        },
                      );
                      updateFormulaValues(tax,
                          "in"); //fetch exisiting value from formula and update new value.
                      showAlertDialog(
                        context,
                        titleSuccess,
                        subtitleSuccess,
                        getRightIcon(),
                      );
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
  String amount = "";

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                amount = value;
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
                    FirebaseFirestore.instance.collection("inExtra").add(
                      {
                        'reason': reason,
                        'amount': amount,
                        'date': DateTime.now().toString(),
                        'user': userMail,
                      },
                    );
                    updateFormulaValues(amount,
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
