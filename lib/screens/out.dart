import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'formula.dart';
import 'package:money/constants.dart';

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
    bool onPressedOut = false;
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          yearTile(clr: clrRed),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: msgEnterFullName,
                labelText: labelName,
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return msgEnterFullName;
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
                  hintText: msgMoneySpendingReason,
                  labelText: labelReason),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return msgMoneySpendingReason;
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
                hintText: msgMoneySpent,
                labelText: labelAmount,
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return msgMoneySpent;
                }
                if (!isNumeric(value)) {
                  return msgOnlyNumber;
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
                hintText: labelExtraInfo,
                labelText: labelExtraInfo,
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
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate() &&
                      onPressedOut == false) {
                    onPressedOut = true;
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msgProcessingData),
                      ),
                    );

                    await FirebaseFirestore.instance
                        .collection(village + pin)
                        .doc(docMainDb)
                        .collection(collPrefixOut + dropdownValueYear)
                        .add(
                      {
                        keyName: name,
                        keyReason: reason,
                        keyAmount: amount,
                        keyExtraInfo: extraInfo,
                        keyDate: DateTime.now().toString(),
                        keyUser: userMail,
                      },
                    );
                    updateFormulaValues(amount.toString(),
                        collPrefixOut); //fetch exisiting value from formula and update new value.

                    popAlert(
                      context,
                      titleSuccess,
                      subtitleSuccess,
                      getRightIcon(50.0),
                      2,
                    );
                  }
                },
                child: Text(
                  bLabelSubmit,
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

  String pageName = actOut;

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
