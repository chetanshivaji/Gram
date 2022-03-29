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

String uidHintText = msgEnterUid;
var mobileUids;
bool uidTextField = false;
String uidList = "";

// Create a corresponding State class.
// This class holds data related to the form.
class HouseWaterFormState extends State<HouseWaterForm> {
  bool onPressedHouseWater = false;
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String email = "";
  int amount = 0;

  String mobile = "";
  String uid = "";
  int waterAmount = 0;
  int houseAmount = 0;
  String waterName = "";
  String houseName = "";
  String waterEmail = "";
  String houseEmail = "";
  var _textController_mobile = TextEditingController();
  var _textController_Uid = TextEditingController();

  Future<void> createPDFInHouseWaterReceiptEntries() async {
    //START - fetch data to display in pdf
    final receipt = receivedReceipt(
      info: receiptInfo(
          date: getCurrentDateTimeInDHM(),
          name: name,
          amount: amount.toString(),
          mobile: mobile,
          userMail: registeredName,
          taxType: (widget.formType == txtTaxTypeHouse) ? keyHouse : keyWater),
    );

    final pdfFile =
        await receipt.generate(actIn + dropdownValueYear, registeredName);

    //PdfApi.openFile(pdfFile);
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

  ListTile getYearTile(Color clr) {
    return ListTile(
      trailing: DropdownButton(
        borderRadius: BorderRadius.circular(12.0),
        dropdownColor: clrGreen,

        alignment: Alignment.topLeft,

        // Initial Value
        value: dropdownValueYear,
        // Down Arrow Icon
        icon: Icon(
          Icons.date_range,
          color: clrGreen,
        ),
        // Array list of items
        items: items.map(
          (String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          },
        ).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) {
          setState(
            () {
              dropdownValueYear = newValue!;
              name = '';
              amount = 0;
              email = '';
              mobile = '';
              _textController_mobile.clear();
            },
          );
        },
      ),
    );
  }

  void setNameEmail(String uid) async {
    //fecth and display user info on screen

    if (widget.formType == txtTaxTypeHouse) {
      try {
        await FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + dropdownValueYear)
            .doc(mobile.toString() + uid)
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
        popAlert(
            context, kTitleTryCatchFail, e.toString(), getWrongIcon(50.0), 1);
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
            .doc(mobile.toString() + uid)
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
        popAlert(
            context, kTitleTryCatchFail, e.toString(), getWrongIcon(50.0), 1);
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

  Future<void> checkMobileUid(mobValue) async {
    String uids = "";
    mobile =
        mobValue; //set here, otherewise this will be set in validator after click on submit.
    try {
      await FirebaseFirestore.instance
          .collection(village + pin)
          .doc(docMobileUidMap)
          .get()
          .then(
        (value) async {
          if (value.exists) {
            var y = value.data();
            if (!y!.containsKey(mobValue)) {
              //mobile uid mapping not present.
              popAlert(
                context,
                kTitleMobileNotPresent,
                "",
                getWrongIcon(50),
                1,
              );
              return;
            }
            mobileUids = y[mobValue];
            //get all uids. if only one directly display
            if (mobileUids.length == 1) {
              uids = mobileUids[0];
              setState(
                () {
                  uidTextField =
                      false; //disale to edit , make enable false or read only true. check it.
                  _textController_Uid.text = mobileUids[0];
                },
              );
              setNameEmail(mobileUids[0]);
            } else if (mobileUids.length > 1) {
              //display all uids and choose one.
              for (var id in mobileUids) {
                uids = uids + ", " + id;
              }
              //pop up message with all uids and setup hint text with uids.
              popAlert(
                context,
                kTitleMultiUids,
                uids,
                getMultiUidIcon(50),
                1,
              );

              setState(
                () {
                  uidTextField =
                      true; //disale to edit , make enable false or read only true. check it.
                  uidList = uids;
                  uidHintText = uidList;
                },
              );
            } else {
              //mobile not found pop alert
              popAlert(
                context,
                kTitleMobileNotPresent,
                "",
                getWrongIcon(50),
                1,
              );
            }
          }
        },
      );
    } catch (e) {
      popAlert(
        context,
        kTitleMobileNotPresent,
        "",
        getWrongIcon(50),
        1,
      );
      // _textController_newMobile.clear();
    }
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
          //yearTile(clr: clrGreen),
          getYearTile(clrGreen),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          TextFormField(
            controller: _textController_mobile,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.mobile_friendly),
                hintText: msgEnterMobileNumber,
                labelText: labelMobile),

            onChanged: (text) async {
              if (text.length < 10) {
                setState(
                  () {
                    name = "";
                    amount = 0;
                    email = "";

                    houseName = "";
                    houseAmount = 0;
                    houseEmail = "";

                    waterName = "";
                    waterAmount = 0;
                    waterEmail = "";
                  },
                );
              }
              if (text.length == 10) {
                mobile = text;
                checkMobileUid(mobile);
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
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          TextFormField(
            controller: _textController_Uid,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.wb_incandescent_outlined),
                hintText: uidHintText,
                labelText: labelUid),
            onFieldSubmitted: (val) {
              uid = val;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return msgEnterUid;
              }

              uid = value;
              return null;
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                setNameEmail(_textController_Uid.text);
              },
              child: Text(
                bLabelAdd,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Expanded(
            child: ListTile(
              leading: Icon(Icons.person),
              title: getPrefilledListTile("Name", name),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Expanded(
            child: ListTile(
              leading: Icon(Icons.person),
              title: getPrefilledListTile("Mail", email),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Expanded(
            child: ListTile(
              leading: Icon(Icons.attach_money),
              title: getPrefilledListTile("Amount", amount.toString()),
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
                            .doc(mobile.toString() + uid)
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
                              .doc(mobile.toString() + uid)
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
                            keyUid: uid,
                            keyAmount: amount,
                            keyDate: getCurrentDateTimeInDHM(),
                            keyRegisteredName: registeredName,
                          },
                        );

                        updateFormulaValues(amount,
                            "in"); //fetch exisiting value from formula and update new value.
                        updateYearWiseFormula(amount, "in", widget.formType);

                        String message =
                            "Dear $name $mobile, Thanks for paying $typeSubmit tax amount $amount for year$dropdownValueYear, Received!. Gram-$village Pin-$pin ";
                        List<String> recipents = [mobile];

                        await createPDFInHouseWaterReceiptEntries();

                        String subject =
                            "$name $typeSubmit Tax receipt for year $dropdownValueYear";
                        String body = """$message
Please find attached receipt

Regards,
$registeredName
""";
                        String attachment = gReceiptPdfName;

                        List<String> receipients = [
                          email,
                          adminMail,
                        ];
                        await sendEmail(subject, body, receipients,
                            attachment); //send mail to user cc admin

                        if (textMsgEnabled) {
                          await sendTextToPhone(
                              message + "-" + registeredName, recipents);
                        }

                        if (whatsUpEnabled) {
                          await launchWhatsApp(
                              message + "-" + registeredName, mobile);
                        }

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
                          keyDate: getCurrentDateTimeInDHM(),
                          keyRegisteredName: registeredName,
                        },
                      );
                      updateFormulaValues(amount,
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
    onPressedDrawerIn = false; //makes drawer enable next time it goes
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
