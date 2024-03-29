import 'dart:io';
//import 'package:flutter/material.dart';  //dont user material.dart or it will mix up with pdf creation apis
import 'package:money/api/pdf_api.dart';
import 'package:money/util.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:money/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget getTableOnPDF(List<dynamic>? headers, List<List<dynamic>> data) {
  return Table.fromTextArray(
    headers: headers,
    data: data,
    border: null,
    cellStyle: myPdfTableCellFontStyle,
    headerStyle:
        myPdfTableCellFontStyle, //TextStyle(fontWeight: FontWeight.bold),
    headerDecoration: BoxDecoration(color: PdfColors.grey300),
    cellHeight: 30,
    cellAlignments: {
      0: Alignment.center,
      1: Alignment.center,
      2: Alignment.center,
      3: Alignment.center,
      4: Alignment.center,
      5: Alignment.center,
      6: Alignment.center,
    },
  );
}

//********************END HouseWater report invoice****************************** */

class pendingReceiptInfo {
  final String date;
  final bool houseGiven;
  final bool waterGiven;
  final String taxType;
  final String name;
  final String houseTax;
  final String waterTax;
  final String electricityTax;
  final String healthTax;
  final String extraLandTax;
  final String otherTax;
  final String totalTax;
  final String mobile;
  final String uid;
  final String userMail;

  const pendingReceiptInfo({
    required this.date,
    required this.houseGiven,
    required this.waterGiven,
    required this.taxType,
    required this.name,
    required this.houseTax,
    required this.waterTax,
    required this.electricityTax,
    required this.healthTax,
    required this.extraLandTax,
    required this.otherTax,
    required this.totalTax,
    required this.mobile,
    required this.uid,
    required this.userMail,
  });
}

class pendingReceipt {
  final pendingReceiptInfo info;
  const pendingReceipt({
    required this.info,
  });
  //year date, name, mobile, amount, tax type, userMail(reciver).
  //Gram Details, - village, taluka, district, state, pin,
  //Stamp, Signature

  Future<File> generate(String reportType, String userMail) async {
    final pdf = Document();

    String pdfName = info.name +
        "_" +
        info.mobile +
        "_" +
        info.uid +
        "_" +
        reportType +
        "_" +
        //info.taxType +
        //"_" +
        //AppLocalizations.of(gContext)!.txtReceipt; //Pdf only in english because of Marathi font disturbed.
        txtReceipt;

    pdfName = pdfName.replaceAll(' ', '_');
    String pdfTitle = pdfName;
    pdfName = pdfName + ".pdf";

    pdf.addPage(
      MultiPage(
        build: (context) => [
          buildHeader(pdfName),
          SizedBox(height: 1 * PdfPageFormat.cm),
          buildTitle(pdfTitle),
          buildInvoice(reportType),
          pw.Text(
            getReceipt(info),
            style: myPdfTableCellFontStyle,
          ),
        ],
        footer: (context) => buildFooter(userMail, reportType),
      ),
    );

    return await PdfApi.saveDocument(name: pdfName, pdf: pdf);
  }

  Widget buildHeader(String pdfName) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: pdfName,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
        ],
      );

  Widget buildTitle(String pdfTitle) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(pdfTitle,
              style:
                  myPdfTableCellFontStyle //TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          /*
          //Pdf only in english because of Marathi font disturbed.
          Text(
            AppLocalizations.of(gContext)!.txtTaxType +
                equals +
                info.taxType +
                endL +
                AppLocalizations.of(gContext)!.tableHeadingName +
                equals +
                info.name +
                endL +
                AppLocalizations.of(gContext)!.tableHeadingMobile +
                equals +
                info.mobile +
                endL +
                AppLocalizations.of(gContext)!.txtSentByUser +
                equals +
                info.userMail +
                endL,
            style: myPdfTableCellFontStyle,
          ),
          */
          (!info.houseGiven && !info.waterGiven)
              ? Text(
                  tableHeadingName +
                      equals +
                      info.name +
                      endL +
                      tableHeadingMobile +
                      equals +
                      info.mobile +
                      endL +
                      txtSentByUser +
                      equals +
                      info.userMail +
                      endL +
                      labelHouseTax +
                      equals +
                      info.houseTax +
                      endL +
                      labelElectricityTax +
                      equals +
                      info.electricityTax +
                      endL +
                      labelHealthTax +
                      equals +
                      info.healthTax +
                      endL +
                      labelExtraLandTax +
                      equals +
                      info.extraLandTax +
                      endL +
                      labelOtherTax +
                      equals +
                      info.otherTax +
                      endL +
                      labelTotalTax +
                      equals +
                      info.totalTax +
                      endL +
                      labelWaterTax +
                      equals +
                      info.waterTax +
                      endL,
                  style: myPdfTableCellFontStyle,
                )
              : info.houseGiven
                  ? Text(
                      tableHeadingName +
                          equals +
                          info.name +
                          endL +
                          tableHeadingMobile +
                          equals +
                          info.mobile +
                          endL +
                          txtSentByUser +
                          equals +
                          info.userMail +
                          endL +
                          labelWaterTax +
                          equals +
                          info.waterTax +
                          endL,
                      style: myPdfTableCellFontStyle,
                    )
                  : Text(
                      tableHeadingName +
                          equals +
                          info.name +
                          endL +
                          tableHeadingMobile +
                          equals +
                          info.mobile +
                          endL +
                          txtSentByUser +
                          equals +
                          info.userMail +
                          endL +
                          labelHouseTax +
                          equals +
                          info.houseTax +
                          endL +
                          labelElectricityTax +
                          equals +
                          info.electricityTax +
                          endL +
                          labelHealthTax +
                          equals +
                          info.healthTax +
                          endL +
                          labelExtraLandTax +
                          equals +
                          info.extraLandTax +
                          endL +
                          labelOtherTax +
                          equals +
                          info.otherTax +
                          endL +
                          labelTotalTax +
                          equals +
                          info.totalTax +
                          endL,
                      style: myPdfTableCellFontStyle,
                    ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildFooter(String userMail, String reportType) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              //title: AppLocalizations.of(gContext)!.appMainLabel,////Pdf only in english because of Marathi font disturbed.
              title: appMainLabel,
              value: village + txtFwdSlash + pin),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              //title: AppLocalizations.of(gContext)!.txtType, value: reportType),//Pdf only in english because of Marathi font disturbed.
              title: txtType,
              value: reportType),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        //Text(title, style: style),
        Text(title, style: myPdfTableCellFontStyle),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value, style: myPdfTableCellFontStyle),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(
            //child: Text(title, style: style),
            child: Text(title, style: myPdfTableCellFontStyle),
          ),
          //Text(value, style: unite ? style : null),
          Text(value, style: myPdfTableCellFontStyle),
        ],
      ),
    );
  }

  String getReceipt(pendingReceiptInfo info) {
    /*
    //Pdf only in english because of Marathi font disturbed.
    return AppLocalizations.of(gContext)!.txtDear +
        " " +
        info.name +
        ", " +
        AppLocalizations.of(gContext)!.txtReminderPending +
        info.taxType +
        AppLocalizations.of(gContext)!.txtTaxAmount +
        " Rs. " +
        info.amount +
        ", " +
        AppLocalizations.of(gContext)!.txtPleasePay;
        */
    String tax = "";

    if (!info.houseGiven && !info.waterGiven) {
      tax = txtTaxTypeHouse +
          " Rs. " +
          info.totalTax +
          ", " +
          txtTaxTypeWater +
          " Rs. " +
          info.waterTax;
    } else if (info.houseGiven) {
      tax = txtTaxTypeWater + " Rs. " + info.waterTax;
    } else if (info.waterGiven) {
      tax = txtTaxTypeHouse + " Rs. " + info.totalTax;
    }
    return txtDear +
        " " +
        info.name +
        ", " +
        txtReminderPending +
        txtTaxAmount +
        " " +
        tax +
        ", " +
        txtPleasePay;
  }

  Widget buildInvoice(String reportType) {
/*
    //Pdf only in english because of Marathi font disturbed.
    headers = [
      AppLocalizations.of(gContext)!.tableHeadingName,
      AppLocalizations.of(gContext)!.tableHeadingMobile,
      AppLocalizations.of(gContext)!.tableHeadingUid,
      AppLocalizations.of(gContext)!.tableHeadingAmount,
      AppLocalizations.of(gContext)!.tableHeadingDate,
    ];
    */

    List headers = [];
    List<List<dynamic>> lld = [];

    if (!info.houseGiven && !info.waterGiven) {
      headers = [
        tableHeadingName,
        tableHeadingMobile,
        tableHeadingUid,
        tableHeadingHouse,
        tableHeadingWater,
        tableHeadingDate,
      ];

      lld = [
        [
          info.name,
          info.mobile,
          info.uid,
          info.totalTax,
          info.waterTax,
          info.date
        ],
      ];
    } else if (info.houseGiven) {
      headers = [
        tableHeadingName,
        tableHeadingMobile,
        tableHeadingUid,
        tableHeadingWater,
        tableHeadingDate,
      ];

      lld = [
        [info.name, info.mobile, info.uid, info.waterTax, info.date],
      ];
    } else if (info.waterGiven) {
      headers = [
        tableHeadingName,
        tableHeadingMobile,
        tableHeadingUid,
        tableHeadingHouse,
        tableHeadingDate,
      ];

      lld = [
        [info.name, info.mobile, info.uid, info.totalTax, info.date],
      ];
    }

    return getTableOnPDF(headers, lld);
  }
}

//********************START pending invoice****************************** */

  