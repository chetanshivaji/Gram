import 'package:flutter/material.dart';
import 'package:money/constants.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'formula.dart';
import 'package:money/communication.dart';
import 'package:money/api/pdf_api.dart';
import 'package:money/model/receipt.dart';

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
  String email = "";
  int amount = 0;

  String mobile = "";
  int waterAmount = 0;
  int houseAmount = 0;
  String waterName = "";
  String houseName = "";
  String waterEmail = "";
  String houseEmail = "";

  void updateFormulaValues(String newEntryAmount, String typeInOut) async {
    var ls = await getLoggedInUserVillagePin();
    int total = await FirebaseFirestore.instance
        .collection(ls[0] + ls[1])
        .doc(mainDb)
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
          .collection(ls[0] + ls[1])
          .doc(mainDb)
          .collection("formula")
          .doc("calculation")
          .update({'totalIn': (total + int.parse(newEntryAmount))});
    } else {
      FirebaseFirestore.instance
          .collection(ls[0] + ls[1])
          .doc(mainDb)
          .collection("formula")
          .doc("calculation")
          .update({'totalOut': (total + int.parse(newEntryAmount))});
    }
  }

  Future<void> createPDFInHouseWaterReceiptEntries() async {
    //START - fetch data to display in pdf

    final receipt = receivedReceipt(
      info: receiptInfo(
          date: DateTime.now().toString(),
          name: name,
          amount: amount.toString(),
          mobile: mobile,
          userMail: userMail,
          taxType: (widget.formType == "HOUSE") ? "house" : "water"),
    );

    final pdfFile = await receipt.generate("IN", userMail);

    PdfApi.openFile(pdfFile);
    return;
    //END - fetch data to display in pdf
  }

  @override
  Widget build(BuildContext context) {
    bool onPressedHouseWater = false;
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.mobile_friendly),
                  hintText: "Enter mobile number",
                  labelText: "Mobile *"),

              onChanged: (text) async {
                if (text.length == 10) {
                  var ls = await getLoggedInUserVillagePin();
                  if (widget.formType == "HOUSE") {
                    try {
                      await FirebaseFirestore.instance
                          .collection(ls[0] + ls[1])
                          .doc(mainDb)
                          .collection(dbYearPrefix + dropdownValueYear)
                          .doc(text)
                          .get()
                          .then(
                        (value) {
                          var y = value.data();
                          houseName = y!["name"];
                          houseEmail = y["email"];
                          houseAmount = y["house"];
                        },
                      );
                    } catch (e) {
                      print(e);
                    }

                    setState(
                      () {
                        name = houseName;
                        amount = houseAmount;
                        email = houseEmail;
                      },
                    );
                  } else {
                    try {
                      await FirebaseFirestore.instance
                          .collection(ls[0] + ls[1])
                          .doc(mainDb)
                          .collection(dbYearPrefix + dropdownValueYear)
                          .doc(text)
                          .get()
                          .then(
                        (value) {
                          var y = value.data();
                          waterAmount = y!["water"];
                          waterName = y["name"];
                          waterEmail = y["email"];
                        },
                      );
                    } catch (e) {
                      print(e);
                    }

                    setState(
                      () {
                        name = waterName;
                        amount = waterAmount;
                        email = waterEmail;
                      },
                    );
                  }
                }
              },

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
                leading: Icon(Icons.person),
                title: Text(
                  "Mail = $email",
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
                  String inTypeSubmit = "";
                  String inTypeGiven = "";
                  String typeSubmit = "";

                  if (widget.formType == "HOUSE") {
                    //house
                    inTypeSubmit = "inHouse";
                    inTypeGiven = 'houseGiven';
                    typeSubmit = 'House';
                  } else {
                    //water
                    inTypeSubmit = "inWater";
                    inTypeGiven = 'waterGiven';
                    typeSubmit = 'Water';
                  }

                  if (_formKey.currentState!.validate() &&
                      onPressedHouseWater == false) {
                    onPressedHouseWater = true;
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    var ls = await getLoggedInUserVillagePin();
                    bool paid = await FirebaseFirestore.instance
                        .collection(ls[0] + ls[1])
                        .doc(mainDb)
                        .collection(dbYearPrefix + dropdownValueYear)
                        .doc(mobile.toString())
                        .get()
                        .then(
                      (value) {
                        var y = value.data();
                        if (widget.formType == "HOUSE") {
                          if (y!["houseGiven"] == true) {
                            return true;
                          } else
                            return false;
                        } else {
                          if (y!["waterGiven"] == true) {
                            return true;
                          } else
                            return false;
                        }
                      },
                    );
                    if (paid == true) {
                      popAlert(context, 'Already Paid', "", getWrongIcon(), 2);
                      return;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );

                      await FirebaseFirestore.instance
                          .collection(ls[0] + ls[1])
                          .doc(mainDb)
                          .collection(inTypeSubmit + dropdownValueYear)
                          .add(
                        {
                          'name': name,
                          'mobile': mobile,
                          'amount': amount,
                          'date': DateTime.now().toString(),
                          'user': userMail,
                        },
                      );
                      await FirebaseFirestore.instance
                          .collection(ls[0] + ls[1])
                          .doc(mainDb)
                          .collection(dbYearPrefix + dropdownValueYear)
                          .doc(mobile)
                          .update({inTypeGiven: true});

                      updateFormulaValues(amount.toString(),
                          "in"); //fetch exisiting value from formula and update new value.

                      String message =
                          "Dear $name $mobile, Thanks for paying $typeSubmit amount $amount, Received! --$email";
                      List<String> recipents = [mobile];
                      if (textMsgEnabled)
                        await sendTextToPhone(message, recipents);

                      if (whatsUpEnabled)
                        await launchWhatsApp(message, "+91" + mobile);

                      await createPDFInHouseWaterReceiptEntries();

                      String subject =
                          "$name $typeSubmit Tax receipt for year $dropdownValueYear";
                      String body =
                          "Please find attached receipt, Thank you!--Regards,\n $email";
                      String attachment = gReceiptPdfName;
                      await sendEmail(subject, body, email, attachment);

                      popAlert(context, titleSuccess, subtitleSuccess,
                          getRightIcon(), 2);
                    }

                    // Validate returns true if the form is valid, or false otherwise.
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
    bool onPressedInExtra = false;
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
                  if (_formKey.currentState!.validate() &&
                      onPressedInExtra == false) {
                    onPressedInExtra = true;
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Processing Data'),
                      ),
                    );
                    var ls = await getLoggedInUserVillagePin();
                    FirebaseFirestore.instance
                        .collection(ls[0] + ls[1])
                        .doc(mainDb)
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

                    popAlert(context, titleSuccess, subtitleSuccess,
                        getRightIcon(), 2);
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
