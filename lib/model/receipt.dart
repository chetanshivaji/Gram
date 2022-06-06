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

class receiptInfo {
  final String date;
  final String taxType;
  final String name;
  final String amount;

  final String electricityTax;
  final String healthTax;
  final String extraLandTax;
  final String otherTax;
  final String totalTax;
  final String discount;
  final String fine;

  final String mobile;
  final String uid;
  final String userMail;

  const receiptInfo({
    required this.date,
    required this.taxType,
    required this.name,
    required this.amount,
    required this.electricityTax,
    required this.healthTax,
    required this.extraLandTax,
    required this.otherTax,
    required this.totalTax,
    required this.discount,
    required this.fine,
    required this.mobile,
    required this.uid,
    required this.userMail,
  });
}

abstract class receipt {
  final receiptInfo info;
  const receipt({
    required this.info,
  });
  //year date, name, mobile, amount, tax type, userMail(reciver).
  //Gram Details, - village, taluka, district, state, pin,
  //Stamp, Signature
  String getReceipt(receiptInfo info) {
    return "Receipt"; //dummy function
  }

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
        info.taxType +
        "_" +
        //AppLocalizations.of(gContext)!.txtReceipt; //Pdf only in english because of Marathi font disturbed.
        txtReceipt;

    pdfName = pdfName.replaceAll(' ', '_');
    String pdfTitle = pdfName;
    pdfName = pdfName + ".pdf";

    pdf.addPage(
      MultiPage(
        build: (context) => [
          buildHeader(pdfName),
          SizedBox(height: 3 * PdfPageFormat.cm),
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
          (info.taxType == txtTaxTypeHouse)
              ? Text(
                  txtTaxType +
                      equals +
                      info.taxType +
                      endL +
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
                      info.amount +
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
                      labelDiscount +
                      equals +
                      info.discount +
                      endL +
                      labelFine +
                      equals +
                      info.fine +
                      endL +
                      labelTotalTax +
                      equals +
                      info.totalTax +
                      endL,
                  style: myPdfTableCellFontStyle,
                )
              : Text(
                  txtTaxType +
                      equals +
                      info.taxType +
                      endL +
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
                      endL,
                  style: myPdfTableCellFontStyle,
                ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  Widget buildInvoice(String reportType) {
    /*
    //Pdf only in english because of Marathi font disturbed.
    return Text(
      AppLocalizations.of(gContext)!.msgInvoidBuildFail,
      style: myPdfTableCellFontStyle,
    );
    */
    return Text(
      msgInvoidBuildFail,
      style: myPdfTableCellFontStyle,
    );
  }

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
}

//********************START pending invoice****************************** */

class pendingReceipt extends receipt {
  const pendingReceipt({
    info,
  }) : super(info: info);

  @override
  String getReceipt(receiptInfo info) {
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
    if (info.taxType == txtTaxTypeHouse) {
      return txtDear +
          " " +
          info.name +
          ", " +
          txtReminderPending +
          info.taxType +
          txtTaxAmount +
          " Rs. " +
          info.totalTax +
          ", " +
          txtPleasePay;
    } else {
      return txtDear +
          " " +
          info.name +
          ", " +
          txtReminderPending +
          info.taxType +
          txtTaxAmount +
          " Rs. " +
          info.amount +
          ", " +
          txtPleasePay;
    }
  }

  @override
  Widget buildInvoice(String reportType) {
    var headers;
    var data;
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
    headers = [
      tableHeadingName,
      tableHeadingMobile,
      tableHeadingUid,
      tableHeadingAmount,
      tableHeadingDate,
    ];
    List<List<dynamic>> lld = [];
    if (info.taxType == txtTaxTypeHouse) {
      lld = [
        [info.name, info.mobile, info.uid, info.totalTax, info.date],
      ];
    } else {
      lld = [
        [info.name, info.mobile, info.uid, info.amount, info.date],
      ];
    }

    return getTableOnPDF(headers, lld);
  }
}
//********************END pending invoice****************************** */

//********************START HouseWater report invoice****************************** */
class receivedReceipt extends receipt {
  const receivedReceipt({
    info,
  }) : super(info: info);

  @override
  String getReceipt(receiptInfo info) {
    /*
    //Pdf only in english because of Marathi font disturbed.
    return AppLocalizations.of(gContext)!.txtDear +
        " " +
        info.name +
        ", " +
        AppLocalizations.of(gContext)!.txtReceived +
        info.taxType +
        AppLocalizations.of(gContext)!.txtTaxAmount +
        " Rs. " +
        info.amount +
        ", " +
        AppLocalizations.of(gContext)!.txtThankYou;
        */
    if (info.taxType == txtTaxTypeHouse) {
      return txtDear +
          " " +
          info.name +
          ", " +
          txtReceived +
          info.taxType +
          txtTaxAmount +
          " Rs. " +
          info.totalTax +
          ", " +
          txtThankYou;
    } else {
      return txtDear +
          " " +
          info.name +
          ", " +
          txtReceived +
          info.taxType +
          txtTaxAmount +
          " Rs. " +
          info.amount +
          ", " +
          txtThankYou;
    }
  }

  @override
  Widget buildInvoice(String reportType) {
    var headers;
    var data;

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
    headers = [
      tableHeadingName,
      tableHeadingMobile,
      tableHeadingUid,
      tableHeadingAmount,
      tableHeadingDate,
    ];
    List<List<dynamic>> lld = [];
    if (info.taxType == txtTaxTypeHouse) {
      lld = [
        [info.name, info.mobile, info.uid, info.totalTax, info.date],
      ];
    } else {
      lld = [
        [info.name, info.mobile, info.uid, info.amount, info.date],
      ];
    }

    return getTableOnPDF(headers, lld);
  }
}
