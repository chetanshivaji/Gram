import 'dart:io';
//import 'package:flutter/material.dart';  //dont user material.dart or it will mix up with pdf creation apis
import 'package:money/api/pdf_api.dart';
import 'package:money/util.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:money/constants.dart';

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
    },
  );
}

//********************END HouseWater report invoice****************************** */

class receiptInfo {
  final String date;
  final String taxType;
  final String name;
  final String amount;
  final String mobile;
  final String userMail;

  const receiptInfo({
    required this.date,
    required this.taxType,
    required this.name,
    required this.amount,
    required this.mobile,
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
        reportType +
        "_" +
        info.taxType +
        "_" +
        '_Receipt';

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
          Text(
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
              title: appMainLabel, value: village + txtFwdSlash + pin),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Type', value: reportType),
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
    return "Dear " +
        info.name +
        " reminder for PENDING " +
        info.taxType +
        " tax amount of Rs. " +
        info.amount +
        " Please pay!";
  }

  @override
  Widget buildInvoice(String reportType) {
    var headers;
    var data;

    headers = [
      tableHeadingName,
      tableHeadingMobile,
      tableHeadingAmount,
      tableHeadingDate,
    ];
    List<List<dynamic>> lld = [
      [info.name, info.mobile, info.amount, info.date],
    ];
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
    return "Dear " +
        info.name +
        " received " +
        info.taxType +
        " tax amount of Rs. " +
        info.amount +
        " Thank you!";
  }

  @override
  Widget buildInvoice(String reportType) {
    var headers;
    var data;

    headers = [
      tableHeadingName,
      tableHeadingMobile,
      tableHeadingAmount,
      tableHeadingDate,
    ];
    List<List<dynamic>> lld = [
      [info.name, info.mobile, info.amount, info.date],
    ];

    return getTableOnPDF(headers, lld);
  }
}
