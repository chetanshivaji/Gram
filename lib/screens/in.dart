import 'package:flutter/material.dart';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'formula.dart';
import 'package:money/communication.dart';
import 'package:money/api/pdf_api.dart';
import 'package:money/model/receipt.dart';
import 'package:money/constants.dart';

// Create a Form widget.
class HouseWaterForm extends StatefulWidget {
  String formType = "";
  HouseWaterForm({Key? key, this.formType = txtTaxTypeHouse}) : super(key: key);

  @override
  HouseWaterFormState createState() {
    return HouseWaterFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class HouseWaterFormState extends State<HouseWaterForm> {
  bool onPressedHouseWater = false;
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
    int total = await FirebaseFirestore.instance
        .collection(village + pin)
        .doc(docMainDb)
        .collection(collFormula)
        .doc(docCalcultion)
        .get()
        .then(
      (value) {
        var y = value.data();
        return (typeInOut == "in") ? y![keyTotalIn] : y![keyTotalOut];
      },
    );

    //update formula
    if (typeInOut == "in") {
      FirebaseFirestore.instance
          .collection(village + pin)
          .doc(docMainDb)
          .collection(collFormula)
          .doc(docCalcultion)
          .update(
        {
          keyTotalIn: (total + int.parse(newEntryAmount)),
        },
      );
    } else {
      FirebaseFirestore.instance
          .collection(village + pin)
          .doc(docMainDb)
          .collection(collFormula)
          .doc(docCalcultion)
          .update(
        {
          keyTotalOut: (total + int.parse(newEntryAmount)),
        },
      );
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
          taxType: (widget.formType == txtTaxTypeHouse) ? keyHouse : keyWater),
    );

    final pdfFile = await receipt.generate(actIn, userMail);

    PdfApi.openFile(pdfFile);
    return;
    //END - fetch data to display in pdf
  }

  void setStateEmptyEntries() {
    setState(
      () {
        name = '';
        amount = 0;
        email = '';
      },
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  hintText: msgEnterMobileNumber,
                  labelText: labelMobile),

              onChanged: (text) async {
                if (text.length == 10) {
                  if (widget.formType == txtTaxTypeHouse) {
                    try {
                      await FirebaseFirestore.instance
                          .collection(village + pin)
                          .doc(docMainDb)
                          .collection(docMainDb + dropdownValueYear)
                          .doc(text)
                          .get()
                          .then(
                        (value) {
                          if (value.exists) {
                            var y = value.data();
                            houseName = y![keyName];
                            houseEmail = y[keyEmail];
                            houseAmount = y[keyHouse];
                          } else {
                            throw kSubTitleUserNotFound;
                          }
                        },
                      );
                    } catch (e) {
                      setStateEmptyEntries();
                      popAlert(context, kTitleTryCatchFail, e.toString(),
                          getWrongIcon(50.0), 1);
                      return;
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
                          .collection(village + pin)
                          .doc(docMainDb)
                          .collection(docMainDb + dropdownValueYear)
                          .doc(text)
                          .get()
                          .then(
                        (value) {
                          if (value.exists) {
                            var y = value.data();
                            waterAmount = y![keyWater];
                            waterName = y[keyName];
                            waterEmail = y[keyEmail];
                          } else {
                            throw kSubTitleUserNotFound;
                          }
                        },
                      );
                    } catch (e) {
                      setStateEmptyEntries();
                      popAlert(context, kTitleTryCatchFail, e.toString(),
                          getWrongIcon(50.0), 1);
                      return;
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
                  return msgOnlyNumber;
                }
                if (value.length != 10) {
                  return msgTenDigitNumber;
                } /*
                if (name == "") {
                  return msgNumberNotFoundInDb;
                }
                */
                if (!isNumeric(value)) {
                  return msgOnlyNumber;
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
              ),
            ),
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
              ),
            ),
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

                  if (widget.formType == txtTaxTypeHouse) {
                    //house
                    inTypeSubmit = collPrefixInHouse;
                    inTypeGiven = keyHouseGiven;
                    typeSubmit = txtTaxTypeHouse;
                  } else {
                    //water
                    inTypeSubmit = collPrefixInWater;
                    inTypeGiven = keyWaterGiven;
                    typeSubmit = txtTaxTypeWater;
                  }

                  if (_formKey.currentState!.validate() &&
                      onPressedHouseWater == false) {
                    try {
                      onPressedHouseWater = true;
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      bool paid = false;
                      try {
                        paid = await FirebaseFirestore.instance
                            .collection(village + pin)
                            .doc(docMainDb)
                            .collection(docMainDb + dropdownValueYear)
                            .doc(mobile.toString())
                            .get()
                            .then(
                          (value) {
                            var y = value.data();
                            if (widget.formType == txtTaxTypeHouse) {
                              if (y![keyHouseGiven] == true) {
                                return true;
                              } else
                                return false;
                            } else {
                              if (y![keyWaterGiven] == true) {
                                return true;
                              } else
                                return false;
                            }
                          },
                        );
                      } catch (e) {
                        throw "Number not found in Database";
                      }
                      if (paid == true) {
                        onPressedHouseWater = false;
                        popAlert(context, paidMsg, "", getWrongIcon(50.0), 2);
                        return;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msgProcessingData),
                          ),
                        );
                        try {
                          await FirebaseFirestore.instance
                              .collection(village + pin)
                              .doc(docMainDb)
                              .collection(docMainDb + dropdownValueYear)
                              .doc(mobile)
                              .update(
                            {inTypeGiven: true},
                          );
                        } catch (e) {
                          throw "Number not found in Database";
                        }

                        await FirebaseFirestore.instance
                            .collection(village + pin)
                            .doc(docMainDb)
                            .collection(
                                inTypeSubmit + DateTime.now().year.toString())
                            .add(
                          {
                            keyName: name,
                            keyMobile: mobile,
                            keyAmount: amount,
                            keyDate: DateTime.now().toString(),
                            keyUser: userMail,
                          },
                        );

                        updateFormulaValues(amount.toString(),
                            "in"); //fetch exisiting value from formula and update new value.

                        String message =
                            "Dear $name $mobile, Thanks for paying $typeSubmit amount $amount, Received!.";
                        List<String> recipents = [mobile];
                        if (textMsgEnabled) {
                          await sendTextToPhone(message + userMail, recipents);
                        }

                        if (whatsUpEnabled) {
                          await launchWhatsApp(message + userMail, mobile);
                        }

                        await createPDFInHouseWaterReceiptEntries();

                        String subject =
                            "$name $typeSubmit Tax receipt for year $dropdownValueYear";
                        String body = """
                          $message \n 
                          Please find attached receipt\n
                          --Regards,
                          \n $userMail
                          """;
                        String attachment = gReceiptPdfName;
                        await sendEmail(subject, body, email, attachment);

                        popAlert(context, titleSuccess, subtitleSuccess,
                            getRightIcon(50.0), 2);
                      }

                      // Validate returns true if the form is valid, or false otherwise.
                    } catch (e) {
                      onPressedHouseWater = false;
                      popAlert(context, kTitleTryCatchFail, e.toString(),
                          getWrongIcon(50.0), 1);
                    }
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
  bool onPressedInExtra = false;

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
          //yearTile(clr: clrGreen),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.text_snippet),
                  hintText: msgExtraIncomeReasom,
                  labelText: labelReason),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return msgExtraIncomeReasom;
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
                  hintText: msgExtraIncomeAmount,
                  labelText: labelAmount),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return msgExtraIncomeAmount;
                }
                if (!isNumeric(value)) {
                  return msgOnlyNumber;
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
                    try {
                      onPressedInExtra = true;
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
                          //.collection(collPrefixInExtra + dropdownValueYear)
                          .collection(collPrefixInExtra +
                              DateTime.now()
                                  .year
                                  .toString()) //put in the date transcation happened
                          .add(
                        {
                          keyReason: reason,
                          keyAmount: amount,
                          keyDate: DateTime.now().toString(),
                          keyUser: userMail,
                        },
                      );
                      updateFormulaValues(amount.toString(),
                          "in"); //fetch exisiting value from formula and update new value.

                      popAlert(context, titleSuccess, subtitleSuccess,
                          getRightIcon(50.0), 2);
                    } catch (e) {
                      onPressedInExtra = false;
                      popAlert(context, kTitleTryCatchFail, e.toString(),
                          getWrongIcon(50.0), 1);
                    }
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

class inMoney extends StatelessWidget {
  static String id = "inscreen";
  inMoney({Key? key}) : super(key: key);

  String pageName = actIn;
  List<Icon> lsIcons = [
    Icon(Icons.home, color: Colors.black),
    Icon(Icons.water, color: Colors.black),
    Icon(Icons.foundation_outlined, color: Colors.black),
  ];
  List<Widget> lsWidget = <Widget>[];
  List<String> lsText = [
    txtTaxTypeHouse,
    txtTaxTypeWater,
    txtTaxTypeExtraIncome
  ];

  @override
  Widget build(BuildContext context) {
    lsWidget.add(
      HouseWaterForm(formType: txtTaxTypeHouse),
    );
    lsWidget.add(
      HouseWaterForm(formType: txtTaxTypeWater),
    );
    lsWidget.add(
      ExtraIncomeForm(),
    );
    Widget infoIcon = Icon(Icons.info);
    return tabScffold(lsIcons.length, lsText, lsIcons, lsWidget, pageName,
        clrGreen, infoIcon);
  }
}
