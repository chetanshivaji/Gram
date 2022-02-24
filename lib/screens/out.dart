import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void _onBasicAlertPressed(context) {
  Alert(
    context: context,
    title: "Success",
    desc: "Submission is recorded",
    image: Image.asset("assets/success.jpeg"),
  ).show();
}

// Create a Form widget.
class outForm extends StatefulWidget {
  const outForm({Key? key}) : super(key: key);

  @override
  outFormState createState() {
    return outFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class outFormState extends State<outForm> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String reason = "";
  int amount = 0;
  String extraInfo = "";
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Enter your name",
                labelText: "Your Name *",
              ),
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
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  icon: Icon(Icons.mobile_friendly),
                  hintText: "Reason for spending money",
                  labelText: "Reason *"),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Reason';
                }
                reason = value;
                return null;
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.attach_money),
                hintText: "Money Spent",
                labelText: "Amount *",
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter money spent';
                }
                amount = int.parse(value);
                return null;
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.info_outline),
                hintText: "Extra Infomation",
                labelText: "Extra information",
              ),
              validator: (value) {
                extraInfo = value.toString();
                return null;
              },
              // The validator receives the text that the user has entered.
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 20,
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Processing Data'),
                      ),
                    );
                    showAlertDialog(
                      context,
                      titleSuccess,
                      subtitleSuccess,
                      getRightIcon(),
                    );
                  }

                  FirebaseFirestore.instance.collection("out").add(
                    {
                      'name': name,
                      'reason': reason,
                      'amount': amount,
                      'extraInfo': extraInfo,
                      'date': DateTime.now().toString(),
                      'user': userMail,
                    },
                  );
                  updateFormulaValues(amount.toString(),
                      "out"); //fetch exisiting value from formula and update new value.

                  _onBasicAlertPressed(context);
                  Navigator.pop(context);
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

class outMoney extends StatelessWidget {
  static String id = "outscreen";

  outMoney({Key? key}) : super(key: key);

  String pageName = "OUT";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageName),
        backgroundColor: clrRed,
      ),
      body: outForm(),
    );
  }
}
