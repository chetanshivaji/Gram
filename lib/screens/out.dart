import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'formula.dart';
import 'package:money/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    gContext = context;
    bool onPressedOut = false;
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //yearTile(clr: clrRed),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: AppLocalizations.of(gContext)!.msgEnterFullName,
                labelText: AppLocalizations.of(gContext)!.labelName + txtStar,
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(gContext)!.msgEnterFullName;
                }
                name = value;
                return null;
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  icon: Icon(Icons.text_snippet),
                  hintText:
                      AppLocalizations.of(gContext)!.msgMoneySpendingReason,
                  labelText:
                      AppLocalizations.of(gContext)!.labelReason + txtStar),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(gContext)!.msgMoneySpendingReason;
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
                hintText: AppLocalizations.of(gContext)!.msgMoneySpent,
                labelText: AppLocalizations.of(gContext)!.labelAmount + txtStar,
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(gContext)!.msgMoneySpent;
                }
                if (!isNumeric(value)) {
                  return AppLocalizations.of(gContext)!.msgOnlyNumber;
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
                hintText: AppLocalizations.of(gContext)!.labelExtraInfo,
                labelText: AppLocalizations.of(gContext)!.labelExtraInfo,
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
                        content: Text(
                            AppLocalizations.of(gContext)!.msgProcessingData),
                      ),
                    );
                    try {
                      await FirebaseFirestore.instance
                          .collection(village + pin)
                          .doc(docMainDb)
                          .collection(
                              collPrefixOut + DateTime.now().year.toString())
                          .add(
                        {
                          keyName: name,
                          keyReason: reason,
                          keyAmount: amount,
                          keyExtraInfo: extraInfo,
                          keyDate: getCurrentDateTimeInDHM(),
                          keyRegisteredName: registeredName,
                        },
                      );
                      await updateFormulaValues(amount,
                          collPrefixOut); //fetch exisiting value from formula and update new value.

                      popAlert(
                        context,
                        AppLocalizations.of(gContext)!.titleSuccess,
                        AppLocalizations.of(gContext)!.subtitleSuccess,
                        getRightIcon(50.0),
                        2,
                      );
                    } catch (e) {
                      onPressedOut = false;
                      popAlert(
                          context,
                          AppLocalizations.of(gContext)!.kTitleTryCatchFail,
                          e.toString(),
                          getWrongIcon(50.0),
                          1);
                    }
                  }
                },
                child: Text(
                  AppLocalizations.of(gContext)!.bLabelSubmit,
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

  @override
  Widget build(BuildContext context) {
    gContext = context;
    String pageName = AppLocalizations.of(gContext)!.pageNameOut;
    onPressedDrawerOut = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageName,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: clrRed,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Container(
            child: outForm(),
          ),
        ),
      ),
    );
  }
}
