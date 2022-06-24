import 'package:flutter/material.dart';
import 'dart:math';
import 'package:money/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'formula.dart';
import 'package:money/communication.dart';
import 'package:money/api/pdf_api.dart';

import 'package:money/model/receipt_received.dart';
import 'package:money/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Create a Form widget.
class HouseWaterForm extends StatefulWidget {
  String formType = "";
  HouseWaterForm({Key? key, this.formType = ""}) : super(key: key);

  @override
  HouseWaterFormState createState() {
    return HouseWaterFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class HouseWaterFormState extends State<HouseWaterForm> {
  List<TextSpan> multiUidsTextSpan = [];
  List<TextSpan> multiUids = [];

  var mobileUids;
  var yearUids;

  bool onPressedHouseWater = false;

  final _formKey = GlobalKey<FormState>();

  String name = "";
  String email = "";

  int electricityTax = 0;
  int healthTax = 0;
  int totalTaxOtherThanWater = 0;
  int totalTaxOtherThanWater_beforeDiscountFine = 0;
  int extraLandTax = 0;
  int otherTax = 0;

  int discount = 0;
  int fine = 0;

  int amount = 0;
  String mobile = "";
  String uid = "";
  int waterAmount = 0;
  int houseAmount = 0;
  String waterName = "";
  String houseName = "";
  String waterEmail = "";
  String houseEmail = "";

  int houseelectricityTax = 0;
  int househealthTax = 0;
  int housetotalTaxOtherThanWater = 0;
  int houseextraLandTax = 0;
  int houseotherTax = 0;

  var _textController_mobile = TextEditingController();
  var _textController_discount = TextEditingController();
  var _textController_fine = TextEditingController();
  bool discountEnabled = true;
  bool fineEnabled = true;

  Future<void> createPDFInHouseWaterReceiptEntries() async {
    //START - fetch data to display in pdf
    final receipt = receivedReceipt(
      info: receivedReceiptInfo(
          date: getCurrentDateTimeInDHM(),
          name: name,
          amount: amount.toString(),
          electricityTax: electricityTax.toString(),
          healthTax: healthTax.toString(),
          extraLandTax: extraLandTax.toString(),
          otherTax: otherTax.toString(),
          totalTax: totalTaxOtherThanWater.toString(),
          mobile: mobile,
          discount: discount.toString(),
          fine: fine.toString(),
          uid: uid,
          userMail: registeredName,
          /*
          //Pdf only in english because of Marathi font disturbed.
          taxType: (widget.formType ==
                  AppLocalizations.of(gContext)!.txtTaxTypeHouse)
              ? AppLocalizations.of(gContext)!.txtTaxTypeHouse
              : AppLocalizations.of(gContext)!.txtTaxTypeWater),
              */
          taxType: (widget.formType ==
                  AppLocalizations.of(gContext)!.txtTaxTypeHouse)
              ? txtTaxTypeHouse
              : txtTaxTypeWater),
    );

    /*
    //Pdf only in english because of Marathi font disturbed.
    final pdfFile = await receipt.generate(
        AppLocalizations.of(gContext)!.pageNameIn + dropdownValueYear,
        registeredName);
        */
    final pdfFile =
        await receipt.generate(pageNameIn + dropdownValueYear, registeredName);
    //PdfApi.openFile(pdfFile);
    return;
    //END - fetch data to display in pdf
  }

  void setStateEmptyEntries() {
    setState(
      () {
        multiUids = [TextSpan()];
        uid = "";
        name = '';
        amount = 0;
        email = '';
        electricityTax = 0;
        healthTax = 0;
        totalTaxOtherThanWater = 0;
        totalTaxOtherThanWater_beforeDiscountFine = 0;
        extraLandTax = 0;
        otherTax = 0;
        _textController_discount.clear();
        _textController_fine.clear();
        fineEnabled = true;
        discountEnabled = true;
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
              multiUids = [TextSpan()];
              uid = "";
              name = '';
              amount = 0;
              email = '';
              mobile = '';

              electricityTax = 0;
              healthTax = 0;
              totalTaxOtherThanWater = 0;
              totalTaxOtherThanWater_beforeDiscountFine = 0;
              extraLandTax = 0;
              otherTax = 0;

              _textController_mobile.clear();
              _textController_discount.clear();
              _textController_fine.clear();
              fineEnabled = true;
              discountEnabled = true;
            },
          );
        },
      ),
    );
  }

  Future<void> setNameEmail(String uid) async {
    //fecth and display user info on screen

    if (widget.formType == AppLocalizations.of(gContext)!.txtTaxTypeHouse) {
      try {
        await FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + dropdownValueYear)
            .doc(mobile + uid)
            .get()
            .then(
          (value) {
            if (value.exists) {
              var y = value.data();
              houseName = y![keyName];
              houseEmail = y[keyEmail];
              houseAmount = y[keyHouse];

              houseelectricityTax = y[keyElectricity];
              househealthTax = y[keyHealth];
              housetotalTaxOtherThanWater = y[keyTotalTaxOtherThanWater];
              houseextraLandTax = y[keyExtraLand];
              houseotherTax = y[keyOtherTax];
            } else {
              throw AppLocalizations.of(gContext)!.kSubTitleUserNotFound;
            }
          },
        );
      } catch (e) {
        setStateEmptyEntries();
        popAlert(context, AppLocalizations.of(gContext)!.kTitleTryCatchFail,
            e.toString(), getWrongIcon(50.0), 1);
        return;
      }

      setState(
        () {
          name = houseName;
          amount = houseAmount;
          email = houseEmail;

          electricityTax = houseelectricityTax;
          healthTax = househealthTax;
          totalTaxOtherThanWater = housetotalTaxOtherThanWater;
          extraLandTax = houseextraLandTax;
          otherTax = houseotherTax;
        },
      );
      totalTaxOtherThanWater_beforeDiscountFine = totalTaxOtherThanWater;
    } else {
      try {
        await FirebaseFirestore.instance
            .collection(village + pin)
            .doc(docMainDb)
            .collection(docMainDb + dropdownValueYear)
            .doc(mobile + uid)
            .get()
            .then(
          (value) {
            if (value.exists) {
              var y = value.data();
              waterAmount = y![keyWater];
              waterName = y[keyName];
              waterEmail = y[keyEmail];
            } else {
              throw AppLocalizations.of(gContext)!.kSubTitleUserNotFound;
            }
          },
        );
      } catch (e) {
        setStateEmptyEntries();
        popAlert(context, AppLocalizations.of(gContext)!.kTitleTryCatchFail,
            e.toString(), getWrongIcon(50.0), 1);
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
    //set here, otherewise this will be set in validator after click on submit.
    mobile = mobValue;

    try {
      await FirebaseFirestore.instance
          .collection(village + pin)
          .doc(docYrsMobileUids)
          .collection(collYrs)
          .doc(dropdownValueYear)
          .get()
          .then(
        (value) async {
          if (value.exists) {
            var y = value.data();
            if (!y!.containsKey(mobValue)) {
              //mobile uid mapping not present.
              popAlert(
                context,
                AppLocalizations.of(gContext)!.kTitleMobileNotPresent,
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
                  uid = mobileUids[0];
                },
              );
              await setNameEmail(mobileUids[0]);
            } else if (mobileUids.length > 1) {
              //display all uids and choose one.
              for (var id in mobileUids) {
                uids = uids + ", " + id;
                multiUidsTextSpan.add(
                  TextSpan(
                    text: id + " , ",
                    style: TextStyle(
                      color: Colors.red[300],
                      backgroundColor: Colors.yellow,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        //make use of Id which has go tapped.
                        uid = id;
                        await setNameEmail(uid);
                      },
                  ),
                );
              }
              //pop up message with all uids and setup hint text with uids.
              popAlert(
                context,
                AppLocalizations.of(gContext)!.kTitleMultiUids,
                uids,
                getMultiUidIcon(50),
                1,
              );

              setState(
                () {
                  multiUids = multiUidsTextSpan;
                },
              );
            } else {
              //mobile not found pop alert
              popAlert(
                context,
                AppLocalizations.of(gContext)!.kTitleMobileNotPresent,
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
        AppLocalizations.of(gContext)!.kTitleMobileNotPresent,
        "",
        getWrongIcon(50),
        1,
      );
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    gContext = context;
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getYearTile(clrGreen),
          //getPadding(),
          TextFormField(
            controller: _textController_mobile,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.mobile_friendly),
                hintText: AppLocalizations.of(gContext)!.msgEnterMobileNumber,
                labelText:
                    AppLocalizations.of(gContext)!.labelMobile + txtStar),

            onChanged: (text) async {
              if ((text.length < 10) || (text.length > 10)) {
                multiUidsTextSpan.clear();
                setState(
                  () {
                    //clear screen fields except mobile contoller text field.
                    multiUids = [TextSpan()];
                    uid = "";

                    name = "";
                    amount = 0;
                    email = "";

                    electricityTax = 0;
                    healthTax = 0;
                    extraLandTax = 0;
                    otherTax = 0;
                    totalTaxOtherThanWater = 0;

                    houseName = "";
                    houseAmount = 0;
                    houseEmail = "";

                    waterName = "";
                    waterAmount = 0;
                    waterEmail = "";
                    _textController_discount.clear();
                    _textController_fine.clear();
                    fineEnabled = true;
                    discountEnabled = true;
                  },
                );
              }
              if (text.length == 10) {
                mobile = text;
                _textController_discount.clear();
                _textController_fine.clear();

                await checkMobileUid(mobile);
                setState(() {
                  fineEnabled = true;
                  discountEnabled = true;
                });
              }
            },

            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(gContext)!.msgOnlyNumber;
              }
              if (value.length != 10) {
                return AppLocalizations.of(gContext)!.msgTenDigitNumber;
              }
              if (!isNumeric(value)) {
                return AppLocalizations.of(gContext)!.msgOnlyNumber;
              }

              mobile = value;
              //check if it is only number
              return null;
            },
          ),
          Center(
            child: RichText(
              text: TextSpan(
                children: multiUids,
              ),
            ),
          ),
          getListTile(Icon(Icons.wb_incandescent_outlined),
              AppLocalizations.of(gContext)!.labelUid, uid),
          //getPadding(),
          getListTile(Icon(Icons.person),
              AppLocalizations.of(gContext)!.labelName, name),
          //getPadding(),
          getListTile(Icon(Icons.mail),
              AppLocalizations.of(gContext)!.labelEmail, email),

          //getPadding(),
          (widget.formType == AppLocalizations.of(gContext)!.txtTaxTypeHouse)
              ? getListTile(
                  Icon(Icons.attach_money),
                  AppLocalizations.of(gContext)!.labelHouseTax,
                  amount.toString())
              : getListTile(
                  Icon(Icons.attach_money),
                  AppLocalizations.of(gContext)!.labelWaterTax,
                  amount.toString()),
          //START electricity health extra land, other tax

          (widget.formType == AppLocalizations.of(gContext)!.txtTaxTypeHouse)
              ? getListTile(
                  Icon(Icons.electrical_services),
                  AppLocalizations.of(gContext)!.labelElectricityTax,
                  electricityTax.toString())
              : SizedBox(),

          (widget.formType == AppLocalizations.of(gContext)!.txtTaxTypeHouse)
              ? getListTile(
                  Icon(Icons.health_and_safety_outlined),
                  AppLocalizations.of(gContext)!.labelHealthTax,
                  healthTax.toString())
              : SizedBox(),

          (widget.formType == AppLocalizations.of(gContext)!.txtTaxTypeHouse)
              ? getListTile(
                  Icon(Icons.landscape_outlined),
                  AppLocalizations.of(gContext)!.labelExtraLandTax,
                  extraLandTax.toString())
              : SizedBox(),

          (widget.formType == AppLocalizations.of(gContext)!.txtTaxTypeHouse)
              ? getListTile(
                  Icon(Icons.movie_creation),
                  AppLocalizations.of(gContext)!.labelOtherTax,
                  otherTax.toString())
              : SizedBox(),

          Row(
            children: <Widget>[
              (widget.formType ==
                      AppLocalizations.of(gContext)!.txtTaxTypeHouse)
                  ? Expanded(
                      child: TextFormField(
                        enabled: discountEnabled,
                        controller: _textController_discount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            icon: Icon(Icons.discount),
                            hintText: AppLocalizations.of(gContext)!
                                .msgDiscountPercent,
                            labelText:
                                AppLocalizations.of(gContext)!.labelDiscount),
                        onChanged: (String? newValue) {
                          if (newValue != "") {
                            totalTaxOtherThanWater =
                                totalTaxOtherThanWater_beforeDiscountFine;
                            int totalAfterDiscount = 0;
                            try {
                              totalAfterDiscount = (totalTaxOtherThanWater -
                                      (totalTaxOtherThanWater *
                                              int.parse(newValue!)) /
                                          100)
                                  .ceil();
                            } catch (e) {
                              popAlert(
                                  context,
                                  AppLocalizations.of(gContext)!
                                      .kTitleTryCatchFail,
                                  e.toString(),
                                  getWrongIcon(50.0),
                                  1);
                            }

                            //set state after of total value after discount.

                            setState(
                              () {
                                fineEnabled = false;
                                totalTaxOtherThanWater = totalAfterDiscount;
                              },
                            );
                          } else {
                            setState(
                              () {
                                totalTaxOtherThanWater =
                                    totalTaxOtherThanWater_beforeDiscountFine;
                                fineEnabled = true;
                              },
                            );
                          }
                        },
                        validator: (value) {
                          if (value!.length != 0 && !isNumeric(value)) {
                            return AppLocalizations.of(gContext)!.msgOnlyNumber;
                          }
                          if (value.length != 0) {
                            discount = int.parse(value);
                          }
                          return null;
                        },
                      ),
                    )
                  : SizedBox(),
              (widget.formType ==
                      AppLocalizations.of(gContext)!.txtTaxTypeHouse)
                  ? Expanded(
                      child: TextFormField(
                        enabled: fineEnabled,
                        controller: _textController_fine,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            icon: Icon(Icons.pin_invoke),
                            hintText:
                                AppLocalizations.of(gContext)!.msgFinePercent,
                            labelText:
                                AppLocalizations.of(gContext)!.labelFine),
                        onChanged: (String? newValue) {
                          if (newValue != "") {
                            totalTaxOtherThanWater =
                                totalTaxOtherThanWater_beforeDiscountFine;
                            int currentYear = DateTime.now().year;
                            int totalAfterFine = 0;
                            DateTime firstAprilCY = DateTime(
                                DateTime.now().year,
                                4,
                                1); //first april current year in DateTime Format.
                            DateTime today = DateTime.now();
                            if (today.isBefore(firstAprilCY)) {
                              currentYear = currentYear - 1;
                            }

                            int yrDiff =
                                (currentYear - int.parse(dropdownValueYear));

                            try {
                              totalAfterFine = (totalTaxOtherThanWater *
                                      pow(
                                        (1 + (int.parse(newValue!) / 100)),
                                        yrDiff,
                                      ))
                                  .ceil();
                            } catch (e) {
                              popAlert(
                                  context,
                                  AppLocalizations.of(gContext)!
                                      .kTitleTryCatchFail,
                                  e.toString(),
                                  getWrongIcon(50.0),
                                  1);
                            }

                            setState(
                              () {
                                discountEnabled = false;
                                totalTaxOtherThanWater = totalAfterFine;
                              },
                            );
                          } else {
                            setState(
                              () {
                                totalTaxOtherThanWater =
                                    totalTaxOtherThanWater_beforeDiscountFine;
                                discountEnabled = true;
                              },
                            );
                          }
                        },
                        validator: (value) {
                          if (value!.length != 0 && !isNumeric(value)) {
                            return AppLocalizations.of(gContext)!.msgOnlyNumber;
                          }
                          if (value.length != 0) {
                            fine = int.parse(value);
                          }
                          return null;
                        },
                      ),
                    )
                  : SizedBox(),
            ],
          ),

          (widget.formType == AppLocalizations.of(gContext)!.txtTaxTypeHouse)
              //special treatment to total list tile, size big
              ? ListTile(
                  minLeadingWidth: 0,
                  leading: Icon(Icons.expand_less_rounded),
                  title: Row(
                    children: [
                      Text(
                        AppLocalizations.of(gContext)!.labelTotalTax + " = ",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        totalTaxOtherThanWater.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          //END electricity health extra land, other tax

          //getPadding(),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  String inTypeSubmit = "";
                  String inTypeGiven = "";
                  String typeSubmit = "";

                  if (widget.formType ==
                      AppLocalizations.of(gContext)!.txtTaxTypeHouse) {
                    //house
                    inTypeSubmit = collPrefixInHouse;
                    inTypeGiven = keyHouseGiven;
                    typeSubmit = AppLocalizations.of(gContext)!.txtTaxTypeHouse;
                  } else {
                    //water
                    inTypeSubmit = collPrefixInWater;
                    inTypeGiven = keyWaterGiven;
                    typeSubmit = AppLocalizations.of(gContext)!.txtTaxTypeWater;
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
                            .doc(mobile + uid)
                            .get()
                            .then(
                          (value) {
                            var y = value.data();
                            if (widget.formType ==
                                AppLocalizations.of(gContext)!
                                    .txtTaxTypeHouse) {
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
                        throw AppLocalizations.of(gContext)!
                            .kSubTitleNumberNotFoundInDB;
                      }
                      if (paid == true) {
                        onPressedHouseWater = false;
                        popAlert(
                            context,
                            AppLocalizations.of(gContext)!.paidMsg,
                            "",
                            getRightIcon(50.0),
                            2);
                        return;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(gContext)!
                                .msgProcessingData),
                          ),
                        );
                        try {
                          await FirebaseFirestore.instance
                              .collection(village + pin)
                              .doc(docMainDb)
                              .collection(docMainDb + dropdownValueYear)
                              .doc(mobile + uid)
                              .update(
                            {
                              inTypeGiven: true,
                            },
                          );
                        } catch (e) {
                          throw AppLocalizations.of(gContext)!
                              .kSubTitleNumberNotFoundInDB;
                        }

                        if (widget.formType ==
                            AppLocalizations.of(gContext)!.txtTaxTypeHouse) {
                          //discount and fine added to inHouse2020 in db which may need to be shown in future
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
                              keyAmount: (widget.formType ==
                                      AppLocalizations.of(gContext)!
                                          .txtTaxTypeHouse)
                                  ? totalTaxOtherThanWater
                                  : amount,
                              keyDate: getCurrentDateTimeInDHM(),
                              keyRegisteredName: registeredName,
                              keyDiscount: discount,
                              keyFine: fine,
                            },
                          );
                        } else {
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
                              keyAmount: (widget.formType ==
                                      AppLocalizations.of(gContext)!
                                          .txtTaxTypeHouse)
                                  ? totalTaxOtherThanWater
                                  : amount,
                              keyDate: getCurrentDateTimeInDHM(),
                              keyRegisteredName: registeredName,
                            },
                          );
                        }

                        int amountHouseOrWater = (widget.formType ==
                                AppLocalizations.of(gContext)!.txtTaxTypeHouse)
                            ? totalTaxOtherThanWater
                            : amount;

                        //user total amount for house - totalTaxOtherThanWater
                        await updateFormulaValues(amountHouseOrWater,
                            txtInType); //fetch exisiting value from formula and update new value.

                        await updateYearWiseFormula(
                            amountHouseOrWater,
                            txtInType,
                            widget.formType,
                            totalTaxOtherThanWater_beforeDiscountFine);

                        //START - multi linugal string
                        String dear = AppLocalizations.of(gContext)!.txtDear;
                        String thanksPaying =
                            AppLocalizations.of(gContext)!.txtThanksPaying;
                        String received =
                            AppLocalizations.of(gContext)!.txtReceived;
                        String taxAmount =
                            AppLocalizations.of(gContext)!.txtTaxAmount;
                        String yr =
                            AppLocalizations.of(gContext)!.tableHeadingYear;
                        String vlg =
                            AppLocalizations.of(gContext)!.labelVillage;
                        String ud =
                            AppLocalizations.of(gContext)!.tableHeadingUid;

                        String taxReceiptYr =
                            AppLocalizations.of(gContext)!.txtTaxReceiptYr;
                        String attachedReceipt =
                            AppLocalizations.of(gContext)!.txtAttachedReceipt;

                        String regards =
                            AppLocalizations.of(gContext)!.txtRegards;

                        String keyord_electricityTax =
                            AppLocalizations.of(gContext)!.labelElectricityTax;
                        String keyord_healthTax =
                            AppLocalizations.of(gContext)!.labelHealthTax;
                        String keyord_extraLandTax =
                            AppLocalizations.of(gContext)!.labelExtraLandTax;
                        String keyord_otherTax =
                            AppLocalizations.of(gContext)!.labelOtherTax;
                        String keyord_totalTax =
                            AppLocalizations.of(gContext)!.labelTotalTax;

                        String keyord_discount =
                            AppLocalizations.of(gContext)!.labelDiscount;
                        String keyord_fine =
                            AppLocalizations.of(gContext)!.labelFine;
                        //END - multi linugal string

                        String message = "";
                        if (widget.formType ==
                            AppLocalizations.of(gContext)!.txtTaxTypeHouse) {
                          message = '''$dear $name,
$mobile
$ud-$uid
$yr $dropdownValueYear
$received, $thanksPaying.
$taxAmount,
$typeSubmit-$amount
$keyord_electricityTax-$electricityTax
$keyord_healthTax-$healthTax
$keyord_extraLandTax-$extraLandTax
$keyord_otherTax-$otherTax
$keyord_discount-$discount
$keyord_fine-$fine
$keyord_totalTax-$totalTaxOtherThanWater

$vlg-$village $pin''';
                        } else {
                          message = '''$dear $name,
$mobile
$ud-$uid
$yr $dropdownValueYear
$received, $thanksPaying.
$taxAmount,
$typeSubmit-$amount

$vlg-$village $pin''';
                        }

                        List<String> recipents = [mobile];

                        await createPDFInHouseWaterReceiptEntries();

                        String subject =
                            "$name, $ud-$uid, $typeSubmit, $taxReceiptYr $dropdownValueYear";
                        String body = '''
$message
$attachedReceipt

$regards,
$registeredName
''';
                        String attachment = gReceiptPdfName;

                        List<String> receipients = [
                          email,
                          adminMail,
                        ];
                        if (textMsgEnabled) {
                          //first send text then email
                          //For english language content template approval,
                          // Just to make viVilPower happy with branch name for brandname
                          if (AppLocalizations.of(gContext)!.language ==
                              "English") {
                            await sendTextToPhone(
                                message +
                                    "\n" +
                                    "-" +
                                    registeredName +
                                    " -PhlySoft",
                                recipents);
                          } else {
                            await sendTextToPhone(
                                message + "\n" + "-" + registeredName,
                                recipents);
                          }
                        }

                        await sendEmail(subject, body, receipients,
                            attachment); //send mail to user cc admin

                        popAlert(
                            context,
                            AppLocalizations.of(gContext)!.titleSuccess,
                            AppLocalizations.of(gContext)!.subtitleSuccess,
                            getRightIcon(50.0),
                            2);
                      }

                      // Validate returns true if the form is valid, or false otherwise.
                    } catch (e) {
                      onPressedHouseWater = false;
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
    gContext = context;
    // Build a Form widget using the _formKey created above.

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getPadding(),
          //getPadding(),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.text_snippet),
                  hintText: AppLocalizations.of(gContext)!.msgExtraIncomeReasom,
                  labelText:
                      AppLocalizations.of(gContext)!.labelReason + txtStar),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(gContext)!.msgExtraIncomeReasom;
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
                  hintText: AppLocalizations.of(gContext)!.msgExtraIncomeAmount,
                  labelText:
                      AppLocalizations.of(gContext)!.labelAmount + txtStar),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(gContext)!.msgExtraIncomeAmount;
                }
                if (!isNumeric(value)) {
                  return AppLocalizations.of(gContext)!.msgOnlyNumber;
                }
                amount = int.parse(value);
                return null;
              },
            ),
          ),
          //getPadding(),
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
                          content: Text(
                              AppLocalizations.of(gContext)!.msgProcessingData),
                        ),
                      );

                      await FirebaseFirestore.instance
                          .collection(village + pin)
                          .doc(docMainDb)
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
                      await updateFormulaValues(amount,
                          txtInType); //fetch exisiting value from formula and update new value.

                      popAlert(
                          context,
                          AppLocalizations.of(gContext)!.titleSuccess,
                          AppLocalizations.of(gContext)!.subtitleSuccess,
                          getRightIcon(50.0),
                          2);
                    } catch (e) {
                      onPressedInExtra = false;
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

class inMoney extends StatelessWidget {
  static String id = "inscreen";
  inMoney({Key? key}) : super(key: key);

  List<Icon> lsIcons = [
    Icon(Icons.home, color: Colors.black),
    Icon(Icons.water, color: Colors.black),
    Icon(Icons.foundation_outlined, color: Colors.black),
  ];
  List<Widget> lsWidget = <Widget>[];

  @override
  Widget build(BuildContext context) {
    gContext = context;
    String actType = actIn;
    String pageName = AppLocalizations.of(gContext)!.pageNameIn;
    List<String> lsText = [
      AppLocalizations.of(gContext)!.txtTaxTypeHouse,
      AppLocalizations.of(gContext)!.txtTaxTypeWater,
      AppLocalizations.of(gContext)!.txtTaxTypeExtraIncome
    ];
    onPressedDrawerIn = false; //makes drawer enable next time it goes
    lsWidget.add(
      HouseWaterForm(formType: AppLocalizations.of(gContext)!.txtTaxTypeHouse),
    );
    lsWidget.add(
      HouseWaterForm(formType: AppLocalizations.of(gContext)!.txtTaxTypeWater),
    );
    lsWidget.add(
      ExtraIncomeForm(),
    );
    Widget infoIcon = Icon(Icons.info);
    return tabScffold(context, lsIcons.length, lsText, lsIcons, lsWidget,
        actType, pageName, clrGreen, infoIcon);
  }
}
